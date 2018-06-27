Rails.application.routes.draw do
  post '/', to: 'proxy#modify'
  delete '/', to: 'proxy#clear'
  root to: 'proxy#embed'
end
