class RankController < ApplicationController
  def index
    client = Octokit::Client.new \
      client_id:     ENV['GiTHUB_CLIENT_ID'],
      client_secret: ENV['GiTHUB_CLIENT_SECRET']
    username = params[:username]

    if username.present?
      @users = []
      begin
        followers = client.followers username
        followers << client.user( username )
      rescue
        followers = []
      end

      followers.each do |follower|
        user = {}

        user[:login] = follower.login
        user[:avatar_url] = follower.avatar_url
        user[:html_url] = follower.html_url
        user[:me] = true if follower.login == username

        streak = Streak.where( username: follower.login ).first
        if streak and streak.updated_at < Time.now.yesterday
          streak.update longest_streak: GitHubScraper::longest_streak( streak.username )
        elsif not streak
          streak = Streak.create username: follower.login, longest_streak: GitHubScraper::longest_streak( follower.login )
        end
        user[:longest_streak] = streak.longest_streak

        @users << user
      end

      @users = @users.sort_by { |val| val[:longest_streak] }
      @users = @users.reverse[0..9]
    else
      redirect_to root_path
    end
  end
end
