class ProxyController < ApplicationController

  skip_before_action :verify_authenticity_token

  def modify
    url = proxy_params['url']
    lifetime = proxy_params['lifetime']

    modified = $redis.get(url)

    if modified.nil? || lifetime

      maxage = get_maxage(url)
      modified = HtmlAnalyzer.modify(url)
      $redis.set(url, modified)
      $redis.expire(url, lifetime || maxage)
    end

    render html: modified.html_safe
  end

  private

  def get_maxage url
    require 'net/http'
    require 'uri'

    uri = URI(url)
    http = Net::HTTP.start(uri.host)
    maxage = 7.days

    resp = http.head(uri.path)
    if resp['cache-control']
      puts resp['cache-control']
      resp['cache-control'].split.each do |elem|
        maxage = elem.scan(/\d+/).first if elem.include? 'max-age='
      end
    end

    http.finish

    maxage
  end

  def proxy_params
     params.require(:data).permit(:url, :lifetime)
  end
end
