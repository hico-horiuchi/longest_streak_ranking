require 'open-uri'

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
        url = "https://github.com/#{follower.login}/"
        html = open( url ) { |f| f.read }
        doc = Nokogiri::HTML.parse html, nil, 'utf-8'

        user[:login] = follower.login
        user[:avatar_url] = follower.avatar_url
        user[:html_url] = follower.html_url
        user[:me] = true if follower.login == params[:username]
        begin
          user[:streak] = doc.css( '.contrib-streak' ).css( '.num' ).inner_html.match( /\A([0-9]+) days\z/ )[1].to_i
        rescue NoMethodError
          user[:streak] = 0
        end

        @users << user
      end

      @users = @users.sort_by { |val| val[:streak] }
      @users = @users.reverse
    else
      redirect_to root_path
    end
  end
end
