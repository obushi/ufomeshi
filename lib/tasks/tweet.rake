namespace :tweet do
  desc "献立をツイートする"

  Client = Twitter::REST::Client.new do |config|
    config.consumer_key        = ENV["CONSUMER_KEY"]
    config.consumer_secret     = ENV["CONSUMER_SECRET"]
    config.access_token        = ENV["OAUTH_TOKEN"]
    config.access_token_secret = ENV["OAUTH_TOKEN_SECRET"]
  end

  def update(time)
    tweet = Meal.today.where(meal_type: time).first&.dishes&.map{|d| d&.name}&.join("/")
    begin
      Client.update(tweet.chomp) if tweet.present?
    rescue => e
      Rails.logger.error "Time: #{Time.now}, Message: #{e.message}\n#{e.backtrace.join("\n")}"
    end
  end

  task breakfast: :environment do
    update(0)
  end

  task lunch: :environment do
    update(1)
  end

  task dinner: :environment do
    update(2)
  end
end
