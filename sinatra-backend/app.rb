require 'sinatra'

set :bind, '0.0.0.0'

get "/" do
  "Priyanka!!! You are awesome!!"
end

get "/health" do
  "OK"
end
