class Marketplace::Craigslist
  def initialize url='http://newyork.craigslist.org/search/sss?excats=20-74-82-14&sort=date&minAsk=100&query=iphone+5+16gb'
    @url = url
  end

  def update
    @rss = SimpleRSS.parse open(@url)
  end

  def populate_listings
    @rss.items.each do |listing|      
      # Listing.create(
      #   listing.url 
      #   listing.description
      #   listing.dc_title
      #   listing.dc_date
      # )
    end
  end

  class << self
    def listing_price listing
      listing.title.scan(/&#x0024;(.*)/).first.try(:first)
    end

    def transaction_price listing
    end

    def list_time listing
      DateTime.parse(listing.dc_date) if listing.dc_date
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

    def model listing
    end

    def brand listing
    end

    def capacity listing
    end

    def color listing
    end

    def carrier listing
    end

    def specs listing
    end
  end
end