class ProxyController < ApplicationController
  skip_before_action :verify_authenticity_token

  include ProxyHelper

  def modify
    url = proxy_params['url']
    lifetime = proxy_params['lifetime']
    type = proxy_params['type'] || 'desktop'

    modified = $redis.get(url)

    if modified.nil? || lifetime

      maxage = get_maxage(url)

      post_proc = get_url_post_proc(url)

      modified = HtmlAnalyzer.modify(url, type == 'desktop' ? HtmlAnalyzer::DESKTOP_USER_AGENT : HtmlAnalyzer::PHONE_USER_AGENT) do |doc|
        post_proc.call(doc) if post_proc
      end

      $redis.set(url, modified)
      $redis.expire(url, lifetime || maxage)
    end

    render html: modified.html_safe
  end

  private

  def proxy_params
    params.require(:data).permit(:url, :lifetime, :type)
  end
end
