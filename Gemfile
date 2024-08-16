# frozen_string_literal: true

source "https://rubygems.org"

group :development, :test do
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
  gem "brakeman", require: false
  # Omakase Ruby styling [https://github.com/rails/rubocop-rails-omakase/]
  gem "rubocop-rails-omakase", require: false
  gem "rspec-rails", "~> 6.1.4"
  gem "factory_bot_rails", "~> 6.4"
  gem "rubocop-rspec", "~> 3.0"
end

group :test do
  gem "shoulda-matchers", "~> 6.2"
  gem "simplecov",        "~> 0.22.0"
end


# Use Redis adapter to run Action Cable in production
# gem "redis", ">= 4.0.1"
# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"
# es not include zoneinfo files, so bundle the tzinfo-data gem
# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]

gem "rails",                      "~> 7.2.0.beta2"
gem "pg",                         "~> 1.1"
gem "puma",                       ">= 5.0"
gem "rack-cache",                 "~> 1.17"
gem "ializer",                    "~> 0.14.0"
gem "devise",                     "~> 4.9"
gem "jsonapi-serializer",         "~> 2.2"
gem "doorkeeper",                 "~> 5.7"
gem "tzinfo-data", platforms: %i[ windows jruby ]
gem "bootsnap", require: false
gem "ffaker",                     "~> 2.23"
gem "image_processing",           "~> 1.2"

gem "rubocop-performance", "~> 1.21"
