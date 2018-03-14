class ProxyController < ApplicationController

  skip_before_action :verify_authenticity_token

  def modify
    url = proxy_params['url']
    lifetime = proxy_params['lifetime']

    modified = $redis.get(url)

    if modified.nil? || lifetime
      modified = HtmlAnalyzer.modify(url)
      $redis.set(url, modified)
      $redis.expire(url, lifetime || 7.days)
    end

    render html: modified.html_safe
  end

  def proxy_params
     params.require(:data).permit(:url, :lifetime)
  end
end
