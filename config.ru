require 'rack'
require_relative 'rack/bi_router'

bi_router = Rack::BIRouter.new
protected_router = Rack::Auth::Basic.new(bi_router) do |username, password|
  Rack::Utils.secure_compare('user', username) && Rack::Utils.secure_compare('pass', password)
end

protected_router.realm = 'Donorbox BI'
pretty_protected_router = Rack::ShowStatus.new(Rack::ShowExceptions.new(protected_router))
Rack::Server.start app: pretty_protected_router, Port: 9292



