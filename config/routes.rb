Rails.application.routes.draw do
  post 'proxy/modify'
  root to: 'proxy#embed'
end
