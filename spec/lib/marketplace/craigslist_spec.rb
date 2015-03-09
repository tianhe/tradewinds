require 'rails_helper'

RSpec.describe Marketplace::Craigslist do
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
      attrs = {dc_date: '2015-03-07T16:35:21-05:00'}
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
    it 'should return Brand New for certain conditions' do
      conditions = {"Brand New" => 'brand new'} 
      conditions.each do |condition|
        attrs = {title: condition[0]}
        item = OpenStruct.new attrs
        expect(Marketplace::Craigslist.condition item).to eq(condition[1])
      end
    end

    it 'should return Mint for certain conditions' do
      conditions = {"MINT iPhone 5" => "mint",
        "Mint Condition" => 'mint',
        "MINT Condition" => 'mint',
        " - Mint " => 'mint'
      }

      conditions.each do |condition|
        attrs = {title: condition[0]}
        item = OpenStruct.new attrs
        expect(Marketplace::Craigslist.condition item).to eq(condition[1])
      end
    end

    it 'should return New for certain conditions' do
      conditions = {"New iPhone 5" => 'new'}

      conditions.each do |condition|
        attrs = {title: condition[0]}
        item = OpenStruct.new attrs
        expect(Marketplace::Craigslist.condition item).to eq(condition[1])
      end
    end

    it 'should return Like New for certain conditions' do
      conditions = {"*Like New*" => 'like new'}

      conditions.each do |condition|
        attrs = {title: condition[0]}
        item = OpenStruct.new attrs
        expect(Marketplace::Craigslist.condition item).to eq(condition[1])
      end
    end

    it 'should return Good for certain conditions' do
      conditions = { "good condition" => 'good',
        "Good condition" => 'good'
      }

      conditions.each do |condition|
        attrs = {title: condition[0]}
        item = OpenStruct.new attrs
        expect(Marketplace::Craigslist.condition item).to eq(condition[1])
      end      
    end

    it 'should return Great for certain conditions' do
      conditions = { "Great Condition" => 'great'}

      conditions.each do |condition|
        attrs = {title: condition[0]}
        item = OpenStruct.new attrs
        expect(Marketplace::Craigslist.condition item).to eq(condition[1])
      end      
    end

    it 'should return nil given an item without title' do
      attrs = {title: "MINTY FRESH"}
      item = OpenStruct.new attrs
      expect(Marketplace::Craigslist.condition item).to eq(nil)
    end
  end

  describe '#color' do
    %w(white black gold blue yellow pink green gray silver)
  end

  describe 'brand' do
    'apple'
  end

  describe 'model' do
    '5 5S 5C 6 6Plus'
  end

  describe 'carrier' do
    %w(sprint at&t sprint verizon unlocked)
  end
end
