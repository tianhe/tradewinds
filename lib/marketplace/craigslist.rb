class Marketplace::Craigslist
  def initialize url
    @url = url
  end

  def fetch_listings
    proxies = HideMyAss::ProxyList.new.fetch
    request = HideMyAss::Request.new(proxies)
    response = request.run(@url)
    @rss = SimpleRSS.parse response.response_body
  end

  def populate_listings
    @rss.items.each do |listing|
      listing_price = Marketplace::Craigslist.listing_price(listing)            
      next if listing_price.to_i > 1000

      model = Marketplace::Craigslist.model(listing.title)
      next unless model

      transaction_price = Marketplace::Craigslist.transaction_price(listing)
      list_time = Marketplace::Craigslist.list_time(listing)
      link = Marketplace::Craigslist.link(listing)
      description = Marketplace::Craigslist.description(listing)
      title = Marketplace::Craigslist.title(listing)
      condition = Marketplace::Craigslist.condition(listing.title) || Marketplace::Craigslist.condition(listing.description)

      brand = Marketplace::Craigslist.brand(listing)      
      capacity = Marketplace::Craigslist.capacity(listing)
      color = Marketplace::Craigslist.color(listing)

      carrier = Marketplace::Craigslist.carrier(listing.title) || Marketplace::Craigslist.carrier(listing.description)
      unlocked = Marketplace::Craigslist.unlocked(listing)
      specs = Marketplace::Craigslist.specs(listing)
      cash = Marketplace::Craigslist.cash(listing.description)
      
      city = Marketplace::Craigslist.city(listing.link)
      neighborhood = Marketplace::Craigslist.neighborhood(listing.link)

      scratches = Marketplace::Craigslist.scratches(listing.description)
      cracked_screen = Marketplace::Craigslist.cracked_screen(listing.description)

      Listing.create(
        listing_price: listing_price,
        transaction_price: transaction_price,
        list_time: list_time,
        url: link,
        condition: condition,
        description: description,
        title: title,
        brand: brand, 
        model: model, 
        capacity: capacity, 
        color: color, 
        carrier: carrier, 
        specs: specs, 
        unlocked: unlocked,
        scratches: scratches,
        cracked_screen: cracked_screen,
        cash: cash,
        city: city,
        neighborhood: neighborhood,
        source: 'craigslist'
      )
    end
  end


  class << self
    def city link
      link.split(".")[0].gsub('http://','')
    end

    def neighborhood link
      parts = link.split("/")
      if parts.length > 5
        return parts[4]
      end
    end

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

    def cash phrase
      !!phrase.match(/cash/i)
    end

    def cracked_screen phrase
      return false if phrase.match(/no crack/i)
      return true if phrase.match(/crack/i)
    end

    def scratches phrase
      return false if phrase.match(/no scratches/i)
      return true if phrase.match(/scratches/i)
    end

    def condition phrase
      phrase = phrase.gsub(/\*/, '')

      if phrase.match(/brand new/i)
        'brand new'
      elsif phrase.match(/ mint /i) || phrase.match(/^mint /i) 
        'mint'
      elsif phrase.match(/like new/i) 
        'like new'
      elsif phrase.match(/ perfect /i) || phrase.match(/^perfect /i) 
        'perfect'
      elsif phrase.match(/ good /i) || phrase.match(/^good /i) 
        'good'
      elsif phrase.match(/ great /i) || phrase.match(/^great /i) 
        'great'
      elsif phrase.match(/ new /i) || phrase.match(/^new /i)
        'new'
      elsif phrase.match(/ excellent /i)
        'excellent'
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
        %w(white black gold blue yellow pink green gray grey silver).each do |c|
          c = 'gray' if c == 'grey'
          return c if listing.description.match(/#{c}/i)
        end
      end
      return nil
    end

    def carrier phrase
      carriers = %w(att sprint verizon tmobile)

      if phrase.present?
        phrase = phrase.gsub(/\&amp;|\&|\-/, '')
        carriers.each do |c|
          return c if phrase.match(/#{c}/i)
        end
      end

      return nil
    end

    def unlocked listing
      if listing.title.try(:match, /unlock/i) || listing.description.try(:match, /unlock/i)
        true
      end
    end

    def model title
      models = {"iphone4s" => "iphone4s",
        "iphone5s" => "iphone5s",
        "iphone5c" => "iphone5c",
        'iphone6\+' => "iphone6plus",
        "iphone6plus" => "iphone6plus",
        "iphone6" => "iphone6",      
        "iphone5" => "iphone5"
      }

      title = title.gsub(/ |\(|\)/,'').downcase
      
      models.each do |m|
        return m[1] if title.match(m[0])
      end

      nil
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

      nil
    end

    def specs listing
    end
  end
end