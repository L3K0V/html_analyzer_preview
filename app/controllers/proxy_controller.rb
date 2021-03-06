class ProxyController < ApplicationController
  skip_before_action :verify_authenticity_token
  after_action :allow_iframe, only: :embed

  include ProxyHelper

  def modify
    url = proxy_params['url']
    lifetime = proxy_params['lifetime']
    user_agent = request.user_agent || HtmlAnalyzer::PHONE_USER_AGENT

    render :modify && return unless url && url =~ URI::regexp

    modified = process_page(url, lifetime, user_agent)

    render html: modified.html_safe
  end

  def embed
    url = params['url']
    lifetime = params['lifetime']
    user_agent = request.user_agent || HtmlAnalyzer::PHONE_USER_AGENT

    render :embed && return unless url && url =~ URI::regexp

    modified = process_page(url, lifetime, user_agent)

    render html: modified.html_safe
  end

  def clear
    render html: helpers.tag.strong($redis.flushall) 
  end

  private

  def process_page(url, lifetime, user_agent)
    modified = $redis.get(url)

    if modified.nil? || lifetime

      maxage = get_maxage(url)

      post_proc = get_url_post_proc(url)

      modified = HtmlAnalyzer.modify(url, user_agent) do |doc|
        post_proc.call(doc) if post_proc
      end

      $redis.set(url, modified)
      $redis.expire(url, lifetime || maxage)
    end

    modified
  end

  def proxy_params
    params.require(:data).permit(:url, :lifetime, :user_agent)
  end

  def allow_iframe
    response.headers.except! 'X-Frame-Options'
  end

  def allow_domain_iframe
    response.headers['X-Frame-Options'] = 'ALLOW-FROM https://example.com'
  end
end
