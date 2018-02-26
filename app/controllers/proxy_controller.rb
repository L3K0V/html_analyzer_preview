class ProxyController < ApplicationController

  skip_before_action :verify_authenticity_token

  def modify
    url = palette_params['url']
    modified = HtmlAnalyzer.modify(url)
    render html: modified.html_safe
  end

  def palette_params
     params.require(:data).permit(:url)
  end
end
