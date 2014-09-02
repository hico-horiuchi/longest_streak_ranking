class RankController < ApplicationController
  def current
    client = Octokit::Client.new \
      client_id:     ENV['GiTHUB_CLIENT_ID'],
      client_secret: ENV['GiTHUB_CLIENT_SECRET']
    session[:username] = params[:username] if session[:username].blank?
    username = session[:username]

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
          github = GitHubScraper::streak( streak.username )
          streak.update current_streak: github[:current], current_streak: github[:current]
        elsif not streak
          github = GitHubScraper::streak( follow.login )
          streak = Streak.create username: follow.login, current_streak: github[:current], current_streak: github[:current]
        end
        user[:current_streak] = streak.current_streak

        @users << user
      end

      @users = @users.sort_by { |val| val[:current_streak] }
      @users = @users.reverse[0..9]
    else
      redirect_to root_path
    end
  end

  def longest
    client = Octokit::Client.new \
      client_id:     ENV['GiTHUB_CLIENT_ID'],
      client_secret: ENV['GiTHUB_CLIENT_SECRET']
    session[:username] = params[:username] if session[:username].blank?
    username = session[:username]

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
          github = GitHubScraper::streak( streak.username )
          streak.update longest_streak: github[:longest], current_streak: github[:current]
        elsif not streak
          github = GitHubScraper::streak( follow.login )
          streak = Streak.create username: follow.login, longest_streak: github[:longest], current_streak: github[:current]
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
