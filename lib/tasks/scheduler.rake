desc "This task is called by the Heroku scheduler add-on"

task :update_pricing_from_craigslist => :environment do
  ulrs = %w(
    http://newyork.craigslist.org/search/sss?excats=20-74-82-14&minAsk=100&query=iphone%205%20&sort=date&format=rss
    http://newyork.craigslist.org/search/sss?excats=20-74-82-14&minAsk=100&query=iphone%206%20&sort=date&format=rss
  )
  
  urls.each do |url|
    craigslist = Marketplace::Craigslist.new(url)
    craigslist.fetch_listings
    craigslist.populate_listings
  end
end
