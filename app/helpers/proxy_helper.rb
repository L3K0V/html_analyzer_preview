module ProxyHelper
  require 'net/http'
  require 'uri'

  def get_url_post_proc(url)
    uri = URI(url)
    return MOPO if uri.host == 'mobil.mopo.de'
  end

  def get_maxage(url)
    # Net::HTTP requires backslash at the end
    url << '/' unless url.end_with?('/')
    
    uri = URI(url)
    http = Net::HTTP.start(uri.host)
    maxage = 7.days

    resp = http.head(uri.path)
    if resp['cache-control']
      resp['cache-control'].split.each do |elem|
        maxage = elem.scan(/\d+/).first if elem.include? 'max-age='
      end
    end

    http.finish

    maxage
  end

  private

  MOPO = proc do |document|
    content = document.search("//div[@class='offcanvas-pagecontent']").first
    content['style'] = 'margin-left: 0%' if content

    header = document.search("//header[@class='page-header' and @role='banner']").first
    header.remove if header
  end
end
