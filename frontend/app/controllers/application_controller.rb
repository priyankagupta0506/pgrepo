class ApplicationController < ActionController::Base
  protect_from_forgery

  def index
     @text = "Of My App"
  end
  get "/health" do
  "OK"
  end
end
