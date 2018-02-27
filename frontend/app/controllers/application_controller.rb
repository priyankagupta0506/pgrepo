class ApplicationController < ActionController::Base
  protect_from_forgery

  def index
     @text = "hello"
#    render text: "Pinkuu  frontend!!"
  end
end
