require 'sinatra'

set :bind, '0.0.0.0'

get "/" do
  "Hello, People!"
end

get "/health" do
  "OK"
end
