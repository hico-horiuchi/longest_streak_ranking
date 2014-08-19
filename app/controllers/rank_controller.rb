class RankController < ApplicationController
  def index
    client = Octokit::Client.new \
      client_id:     ENV['GiTHUB_CLIENT_ID'],
      client_secret: ENV['GiTHUB_CLIENT_SECRET']

    if params[:username].present?
      @users = []
      begin
        followers = client.followers params[:username]
        followers << client.user( params[:username] )
      rescue
        followers = []
      end

      followers.each do |follower|
        user = {}

        user[:login] = follower.login
        user[:avatar_url] = follower.avatar_url
        user[:html_url] = follower.html_url
        user[:me] = true if follower.login == params[:username]
        user[:longest_streak] = GitHubScraper::longest_streak follower.login

        @users << user
      end

      @users = @users.sort_by { |val| val[:longest_streak] }
      @users = @users.reverse
    else
      redirect_to root_path
    end
  end
end
