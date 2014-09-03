module GitHubStreak
  def self.ranking( username, type )
    client = Octokit::Client.new \
      client_id:     ENV['GiTHUB_CLIENT_ID'],
      client_secret: ENV['GiTHUB_CLIENT_SECRET']

    users = []
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
        streak.update current_streak: github[:current], longest_streak: github[:longest]
      elsif not streak
        github = GitHubScraper::streak( follow.login )
        streak = Streak.create username: follow.login, current_streak: github[:current], longest_streak: github[:longest]
      end
      user[:streak] = streak.send "#{type}_streak"

      users << user
    end

    users = users.sort_by { |val| val[:streak] }
    users = users.reverse[0..9]
  end
end
