class ApplicationController < ActionController::Base
  protect_from_forgery

  def index
     @text = "This App"
  end
  get "/health" do
  "OK"
  end
end
