require 'open-uri'

module GitHubScraper
  GIT_HUB_URL = 'https://github.com/'

  def self.profile_page( username )
    url = GIT_HUB_URL + username + '/'
    begin
      return open( url ) { |f| f.read }
    rescue OpenURI::HTTPError
      return nil
    end
  end

  def self.streak( username )
    html = GitHubScraper::profile_page username
    return nil unless html
    doc = Nokogiri::HTML.parse html, nil, 'utf-8'
    streak = {}

    begin
      streak[:longest] = doc.css( '.contrib-streak' ).css( '.num' ).inner_html.match( /\A([0-9]+) days\z/ )[1].to_i
    rescue NoMethodError
      streak[:longest] = 0
    end

    begin
      streak[:current] = doc.css( '.contrib-streak-current' ).css( '.num' ).inner_html.match( /\A([0-9]+) days\z/ )[1].to_i
    rescue NoMethodError
      streak[:current] = 0
    end

    streak
  end
end
