class HideMyAss::ProxyList
  def initialize
    @url = 'http://proxylist.hidemyass.com/search-1337297#listable'
  end

  def fetch
    doc = Nokogiri::HTML(open(@url)) 
    proxies = doc.xpath('//table[@id="listable"]/tbody/tr').collect do |node|
      ip = HideMyAss::IP.new(node.at_xpath('td[2]/span'))

      next unless ip.valid?

      { host: ip.address, port: node.at_xpath('td[3]').content.strip }      
    end.compact
  end
end