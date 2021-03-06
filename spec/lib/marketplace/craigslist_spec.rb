require 'rails_helper'

RSpec.describe Marketplace::Craigslist do
  describe '#city' do
    it 'should locate url of the city' do
      expect(Marketplace::Craigslist.city 'http://newyork.craigslist.org/search/sss?excats=20-74-82-14&minAsk=100&query=iphone%206%20&sort=date&format=rss').to eq('newyork')
    end
  end

  describe '#neighborhood' do
    it 'should locate url of the neighborhood' do
      expect(Marketplace::Craigslist.neighborhood 'http://newyork.craigslist.org/search/mnh/sss?excats=20-74-82-14&minAsk=100&query=iphone%206%20&sort=date&format=rss').to eq('mnh')
    end

    it 'should return nil if the neighborhood doesnt exist' do
      expect(Marketplace::Craigslist.neighborhood 'http://newyork.craigslist.org/search/sss?excats=20-74-82-14&minAsk=100&query=iphone%206%20&sort=date&format=rss').to eq(nil)
    end
  end

  describe '#get_listing_price' do
    it 'should return 240 given an item with title with &#x0024; appended to it' do
      attrs = {title: "MINT iPhone 5 16GB (Sheepshead Bay) &#x0024;240"}
      item = OpenStruct.new attrs
      expect(Marketplace::Craigslist.listing_price item).to eq('240')
    end

    it 'should return nil given an item with title without &#x0024; appended to it' do
      attrs = {title: 'MINT iPhone 5 16GB (Sheepshead Bay)'}
      item = OpenStruct.new attrs
      expect(Marketplace::Craigslist.listing_price item).to eq(nil)
    end
  end

  describe '#get_transaction_price' do
    it 'should return nil' do
      attrs = {title: 'MINT iPhone 5 16GB (Sheepshead Bay)'}
      item = OpenStruct.new attrs
      expect(Marketplace::Craigslist.transaction_price item).to eq(nil)
    end
  end

  describe '#list_date' do
    it 'should return correct datetime given an item with dc_date 2015-03-07T16:35:21-05:00' do
      attrs = {dc_date: DateTime.parse('2015-03-07T16:35:21-05:00')}
      item = OpenStruct.new attrs
      expect(Marketplace::Craigslist.list_time item).to eq(DateTime.parse('2015-03-07T16:35:21-05:00'))
    end

    it 'should return nil given an item without dc_date' do
      attrs = {}
      item = OpenStruct.new attrs
      expect(Marketplace::Craigslist.list_time item).to eq(nil)
    end
  end

  describe '#link' do
    it 'should return correct datetime given an item with link ' do
      attrs = {link: 'http://newyork.craigslist.org/mnh/mob/4902924832.html'}
      item = OpenStruct.new attrs
      expect(Marketplace::Craigslist.link item).to eq('http://newyork.craigslist.org/mnh/mob/4902924832.html')
    end

    it 'should return nil given an item without link' do
      attrs = {}
      item = OpenStruct.new attrs
      expect(Marketplace::Craigslist.link item).to eq(nil)
    end
  end

  describe '#description' do
    it 'should return correct datetime given an item with description ' do
      attrs = {description: "Im selling my iPhone 5 16GB. Mint condition. \nPrice is $240 \nI have the box with the charging block but NO wire. \nLocal Sales only!!!! (preferred pick up) \nNO SCAMS OR OFFERS!!! \nIf you want to buy the phone you can contact me at \n <a href=\"/fb/nyc/mob/4906445846\" class=\"showcontact\" title=\"click to show contact info\">show contact info</a>"}
      item = OpenStruct.new attrs
      expect(Marketplace::Craigslist.description item).to eq("Im selling my iPhone 5 16GB. Mint condition. \nPrice is $240 \nI have the box with the charging block but NO wire. \nLocal Sales only!!!! (preferred pick up) \nNO SCAMS OR OFFERS!!! \nIf you want to buy the phone you can contact me at \n <a href=\"/fb/nyc/mob/4906445846\" class=\"showcontact\" title=\"click to show contact info\">show contact info</a>")
    end

    it 'should return nil given an item without description' do
      attrs = {}
      item = OpenStruct.new attrs
      expect(Marketplace::Craigslist.description item).to eq(nil)
    end
  end

  describe '#title' do
    it 'should return correct datetime given an item with title' do
      attrs = {title: "MINT iPhone 5 16GB (Sheepshead Bay) &#x0024;240" }
      item = OpenStruct.new attrs
      expect(Marketplace::Craigslist.title item).to eq("MINT iPhone 5 16GB (Sheepshead Bay) &#x0024;240")
    end

    it 'should return nil given an item without title' do
      attrs = {}
      item = OpenStruct.new attrs
      expect(Marketplace::Craigslist.title item).to eq(nil)
    end
  end

  describe '#condition' do
    context '#title' do
      it 'should return Brand New for certain conditions' do
        conditions = {"Brand New" => 'brand new'} 
        conditions.each do |condition|
          expect(Marketplace::Craigslist.condition condition[0]).to eq(condition[1])
        end
      end

      it 'should return Mint for certain conditions' do
        conditions = {"MINT iPhone 5" => "mint",
          "Mint Condition" => 'mint',
          "MINT Condition" => 'mint',
          "just phone in mint condition" => 'mint',
          " - Mint " => 'mint'
        }

        conditions.each do |condition|
          expect(Marketplace::Craigslist.condition condition[0]).to eq(condition[1])
        end
      end

      it 'should return New for certain conditions' do
        conditions = {"New iPhone 5" => 'new'}

        conditions.each do |condition|
          expect(Marketplace::Craigslist.condition condition[0]).to eq(condition[1])
        end
      end

      it 'should return Like New for certain conditions' do
        conditions = {"*Like New*" => 'like new'}

        conditions.each do |condition|
          expect(Marketplace::Craigslist.condition condition[0]).to eq(condition[1])
        end
      end

      it 'should return Good for certain conditions' do
        conditions = { "good condition" => 'good',
          "Good condition" => 'good'
        }

        conditions.each do |condition|
          expect(Marketplace::Craigslist.condition condition[0]).to eq(condition[1])
        end      
      end

      it 'should return Great for certain conditions' do
        conditions = { "Great Condition" => 'great'}

        conditions.each do |condition|
          expect(Marketplace::Craigslist.condition condition[0]).to eq(condition[1])
        end      
      end

      it 'should return nil given an item without title' do
        expect(Marketplace::Craigslist.condition '').to eq(nil)
      end
    end

  end

  describe '#color' do
    %w(white black gold blue yellow pink green gray silver).each do |color|
      it "should return #{color} when color is in title" do
        attrs = {title: " #{color.capitalize} "}
        item = OpenStruct.new attrs
        expect(Marketplace::Craigslist.color item).to eq(color)
      end
    end

    %w(white black gold blue yellow pink green gray silver).each do |color|
      it "should return #{color} when color is in body" do
        attrs = {description: " #{color.capitalize} "}
        item = OpenStruct.new attrs
        expect(Marketplace::Craigslist.color item).to eq(color)
      end
    end

    it "should return nil otherwise" do
      attrs = {description: " LOCK "}
      item = OpenStruct.new attrs
      expect(Marketplace::Craigslist.color item).to eq(nil)
    end

  end

  describe '#brand' do
    it 'should return Apple given an item without title' do
      item = {}
      expect(Marketplace::Craigslist.brand item).to eq('Apple')
    end
  end

  describe '#carrier' do
    carriers = {"sprint" => "sprint",
     "at&t" => "att",
     'AT&amp;T' => "att",
     "verizon" => "verizon",
     "t-mobile" => "tmobile" }

    carriers.each do |carrier|
      it "should return #{carrier[1]} when carrier is in descriptioon" do
        expect(Marketplace::Craigslist.carrier " #{carrier[0].capitalize} ").to eq(carrier[1])
      end
    end

    it "should return nil otherwise" do
      expect(Marketplace::Craigslist.carrier " LOCK ").to eq(nil)
    end

  end

  describe 'unlocked' do
    it "should return true when unlock is in title" do
      attrs = {title: " UNLOCKED "}
      item = OpenStruct.new attrs
      expect(Marketplace::Craigslist.unlocked item).to eq(true)
    end

    it "should return true when unlock is in descriptioon" do
      attrs = {description: " UNLOCK "}
      item = OpenStruct.new attrs
      expect(Marketplace::Craigslist.unlocked item).to eq(true)
    end
    
    it "should return nil otherwise" do
      attrs = {description: " L "}
      item = OpenStruct.new attrs
      expect(Marketplace::Craigslist.unlocked item).to eq(nil)
    end
  end

  describe '#cash' do
    it 'should return true if cash is mentioned' do
      expect(Marketplace::Craigslist.cash 'Cash').to eq(true)
    end

    it 'should retun false if cash isnt mentioned' do
      expect(Marketplace::Craigslist.cash '').to eq(false)
    end    
  end

  describe '#scratches' do
    it 'should retunr true if scratch is mentioned' do
      expect(Marketplace::Craigslist.scratches 'small SCRATCHES on back').to eq(true)
    end

    it 'should retunr false if no scratch is mentioned' do
      expect(Marketplace::Craigslist.scratches 'NO SCRATCHES').to eq(false)
    end
  end

  describe '#cracked_screens' do
    it 'should return true if cracked screen is mentioned' do
      expect(Marketplace::Craigslist.cracked_screen 'cracked screen').to eq(true)
      expect(Marketplace::Craigslist.cracked_screen 'small crack').to eq(true)
    end

    it 'should retunr false if no cracks is mentioned' do
      expect(Marketplace::Craigslist.cracked_screen 'no cracks').to eq(false)
    end
  end

  describe '#model' do
    models = {"iPhone 4s" => "iphone4s",
      "iPhone 5" => "iphone5",
      "iPhone 5S" => "iphone5s",
      "iPhone 5 S" => "iphone5s",
      "iPhone 5C" => "iphone5c",
      "iPhone 5 C" => "iphone5c",
      "iPhone 6" => "iphone6",      
      "iPhone 6+" => "iphone6plus", 
      "iPhone 6Plus" => "iphone6plus",
      "iPhone 6 Plus" => "iphone6plus",
      "iPhone 6+ (6 Plus)" => "iphone6plus"
    }
    
    models.each do |model|
      it "should return #{model[1]} when #{model[0]} is in title" do
        expect(Marketplace::Craigslist.model " #{model[0].capitalize} ").to eq(model[1])
      end      
    end

    it "should return nil otherwise" do
      expect(Marketplace::Craigslist.model " LOCK ").to eq(nil)
    end    
  end

  describe 'capacity' do
    capacities = {'8gb' => '8gb',
      '16 GB' => '16gb',
      '32 gb' => '32gb',
      '64gb' => '64gb',
      '128gb' => '128gb'}

    capacities.each do |capacity|
      it "should return #{capacity[1]} when #{capacity[0]} is in title" do
        attrs = {title: " #{capacity[0].capitalize} "}
        item = OpenStruct.new attrs
        expect(Marketplace::Craigslist.capacity item).to eq(capacity[1])
      end      
    end

    it "should return nil otherwise" do
      attrs = {description: " LOCK "}
      item = OpenStruct.new attrs
      expect(Marketplace::Craigslist.capacity item).to eq(nil)
    end
  end
end
