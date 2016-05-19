namespace :tweet do
  desc "献立をツイートする"

  Client = Twitter::REST::Client.new do |config|
    config.consumer_key        = ENV["CONSUMER_KEY"]
    config.consumer_secret     = ENV["CONSUMER_SECRET"]
    config.access_token        = ENV["OAUTH_TOKEN"]
    config.access_token_secret = ENV["OAUTH_TOKEN_SECRET"]
  end

  MealNames = { breakfast: "朝食", lunch: "昼食", dinner: "夕食", all: "" }

  def date(time)
    date = "#{Date.today.strftime("%1m月%1d日")}#{MealNames[time]}の献立です。\n"
  end

  def menu(time)
    if time == :all
      daily_menu = []
      Meal.today.each do |meal|
        daily_menu << "[#{MealNames[meal.meal_type.to_sym]}]#{meal.dishes&.map{|d| d&.name}&.join("/")}"
      end
      daily_menu.join("\n")
    else
      menu = Meal.today.where(meal_type: time.to_s).first&.dishes&.map{|d| d&.name}&.join("/")
    end
  end

  def update(time)
    text = date(time) + menu(time)
    tweet = text.chomp.scan(/.{1,140}/m)
    tweet.reverse_each do |t|
      begin
        Client.update(t) if menu(time).present?
      rescue => e
        Rails.logger.error "Time: #{Time.now}, Message: #{e.message}\n#{e.backtrace.join("\n")}"
      end
    end
  end

  task breakfast: :environment do
    update(:breakfast)
  end

  task lunch: :environment do
    update(:lunch)
  end

  task dinner: :environment do
    update(:dinner)
  end

  task all: :environment do
    update(:all)
  end
end
