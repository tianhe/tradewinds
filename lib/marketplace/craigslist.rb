class Marketplace::Craigslist
  def initialize url='http://newyork.craigslist.org/search/sss?excats=20-74-82-14&minAsk=100&query=iphone%205%2016gb&sort=date&format=rss'
    @url = url
  end

  def fetch_listings
    @rss = SimpleRSS.parse open(@url)
  end

  def populate_listings
    @rss.items.each do |listing|
      binding.pry
      listing_price = Marketplace::Craigslist.listing_price(listing)
      transaction_price = Marketplace::Craigslist.transaction_price(listing)
      list_time = Marketplace::Craigslist.list_time(listing)
      link = Marketplace::Craigslist.link(listing)
      description = Marketplace::Craigslist.description(listing)
      title = Marketplace::Craigslist.title(listing)
      condition = Marketplace::Craigslist.condition(listing)

      brand = Marketplace::Craigslist.brand(listing)
      model = Marketplace::Craigslist.model(listing)
      capacity = Marketplace::Craigslist.capacity(listing)
      color = Marketplace::Craigslist.color(listing)

      carrier = Marketplace::Craigslist.carrier(listing)
      unlocked = Marketplace::Craigslist.unlocked(listing)
      specs = Marketplace::Craigslist.specs(listing)

      product = Product.where(brand: brand, model: model, capacity: capacity, color: color, carrier: carrier, specs: specs, unlocked: unlocked).first_or_create
      source = Source.where(name: 'craigslist').first_or_create

      Listing.create(
        listing_price: listing_price,
        transaction_price: transaction_price,
        list_time: list_time,
        url: link,
        condition: condition,
        description: description,
        title: title,
        product_id: product.id,
        location_id: nil,
        source_id: source.id
      )
    end
  end


  class << self
    def listing_price listing
      listing.title.scan(/&#x0024;(.*)/).first.try(:first)
    end

    def transaction_price listing
    end

    def list_time listing
      listing.dc_date
    end

    def link listing
      listing.link
    end

    def description listing
      listing.description
    end

    def title listing
      listing.title
    end

    def condition listing
      title = listing.title.gsub(/\*/, '')

      if title.match(/brand new/i)
        'brand new'
      elsif title.match(/ mint /i) || title.match(/^mint /i)
        'mint'
      elsif title.match(/like new/i)
        'like new'
      elsif title.match(/ good /i) || title.match(/^good /i) 
        'good'
      elsif title.match(/ great /i) || title.match(/^great /i) 
        'great'
      elsif title.match(/ new /i) ||  title.match(/^new /i)
        'new'
      else
        nil
      end
    end

    def brand listing
      'Apple'
    end

    def color listing
      if listing.title.present?
        %w(white black gold blue yellow pink green gray silver).each do |c|
          return c if listing.title.match(/#{c}/i)
        end
      end

      if listing.description.present?
        %w(white black gold blue yellow pink green gray silver).each do |c|
          return c if listing.description.match(/#{c}/i)
        end
      end
      return nil
    end

    def carrier listing      
      carriers = %w(att sprint verizon tmobile)

      if listing.title.present?
        title = listing.title.gsub(/\&|\-/, '')
        carriers.each do |c|
          return c if title.match(/#{c}/i)
        end
      end

      if listing.description.present?
        description = listing.description.gsub(/\&|\-/, '')
        carriers.each do |c|
          return c if description.match(/#{c}/i)
        end
      end
      return nil
    end

    def unlocked listing
      if listing.title.try(:match, /unlock/i) || listing.description.try(:match, /unlock/i)
        true
      end
    end

    def model listing
      models = {"iphone5s" => "iphone5s",
        "iphone5c" => "iphone5c",
        'iphone6\+' => "iphone6plus",
        "iphone6plus" => "iphone6plus",
        "iphone6" => "iphone6",      
        "iphone5" => "iphone5"
      }

      if listing.title
        title = listing.title.gsub(/ |\(|\)/,'').downcase
        
        models.each do |m|
          return m[1] if title.match(m[0])
        end
      end

      if listing.description
        description = listing.description.gsub(/ |\(|\)/,'').downcase
        
        models.each do |m|
          return m[1] if description.match(m[0])
        end
      end
    end

    def capacity listing
      capacities = {
        '128gb' => '128gb',
        '16gb' => '16gb',
        '32gb' => '32gb',
        '64gb' => '64gb',
        '8gb' => '8gb'
      }

      if listing.title
        title = listing.title.gsub(/ |\(|\)/,'').downcase
        
        capacities.each do |c|
          return c[1] if title.match(c[0])
        end
      end

      if listing.description
        description = listing.description.gsub(/ |\(|\)/,'').downcase
        
        capacities.each do |c|
          return c[1] if description.match(c[0])
        end
      end
    end

    def specs listing
    end
  end
end