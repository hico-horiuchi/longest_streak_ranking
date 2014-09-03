class RankController < ApplicationController
  before_action :get_username

  def current
    @users = GitHubStreak::ranking @username, 'current'
  end

  def longest
    @users = GitHubStreak::ranking @username, 'longest'
  end

  private

  def get_username
    redirect_to root_path if params[:username].blank? and session[:username].blank?
    session[:username] = params[:username] if session[:username].blank?
    @username = session[:username]
  end
end
