require 'sinatra'

set :bind, '0.0.0.0'

get "/" do
  "Hello, Priyanka!!! You are awesome!!"
end

get "/health" do
  "OK"
end
