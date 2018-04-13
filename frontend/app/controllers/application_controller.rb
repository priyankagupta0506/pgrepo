class ApplicationController < ActionController::Base
  protect_from_forgery

  def index
     @text = "This World"
  end
end
