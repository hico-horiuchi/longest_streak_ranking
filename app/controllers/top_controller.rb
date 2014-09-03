class TopController < ApplicationController
  def index
    session[:username] = ''
  end
end
