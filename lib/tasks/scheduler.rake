desc "This task is called by the Heroku scheduler add-on"

task :update_pricing_from_craigslist => :environment do

  %w(newyork sfbay losangeles).each do |city|
    %w(iphone%205 iphone%206).each do |query|
      url = "http://#{city}.craigslist.org/search/sss?excats=20-74-82-14&minAsk=100&query=#{query}&sort=date&format=rss"

      craigslist = Marketplace::Craigslist.new(url)
      craigslist.fetch_listings
      craigslist.populate_listings
    end
  end
end
