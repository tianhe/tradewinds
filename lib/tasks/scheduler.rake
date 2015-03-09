desc "This task is called by the Heroku scheduler add-on"

task :update_pricing_from_craigslist => :environment do
  craigslist = Marketplace::Craigslist.new('http://newyork.craigslist.org/search/sss?excats=20-74-82-14&minAsk=100&query=iphone%205%2016gb&sort=date&format=rss')
  craigslist.fetch_listings
  craigslist.populate_listings
end
