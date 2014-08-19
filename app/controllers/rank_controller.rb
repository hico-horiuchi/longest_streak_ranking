class RankController < ApplicationController
  def index
    client = Octokit::Client.new \
      client_id:     ENV['GiTHUB_CLIENT_ID'],
      client_secret: ENV['GiTHUB_CLIENT_SECRET']
    username = params[:username]

    if username.present?
      @users = []
      begin
        following = client.following username
        following << client.user( username )
      rescue
        following = []
      end

      following.each do |follow|
        user = {}

        user[:login] = follow.login
        user[:avatar_url] = follow.avatar_url
        user[:html_url] = follow.html_url
        user[:me] = true if follow.login == username

        streak = Streak.where( username: follow.login ).first
        if streak and streak.updated_at < Time.now.yesterday
          streak.update longest_streak: GitHubScraper::longest_streak( streak.username )
        elsif not streak
          streak = Streak.create username: follow.login, longest_streak: GitHubScraper::longest_streak( follow.login )
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
