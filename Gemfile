source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby IO.read(".ruby-version").strip

gem "bcrypt",       "~> 3.1.7"
gem "caxlsx",       "~> 3.0.1"
gem "csv",          "~> 3.0"
gem "highline",     "~> 2.0.3"
gem "jbuilder",     "~> 2.7"
gem "mysql2",       ">= 0.4.4"
gem "nokogiri",     "~> 1.10.9"
gem "puma",         "~> 4.1"
gem "rails",        "~> 6.0.2", ">= 6.0.2.2"
gem "rails-i18n",   "~> 6.0.0"
gem "sass-rails",   ">= 6"
gem "simple_form",  "~> 5.0.2"
gem "slim",         "~> 4.0"
gem "strip_attributes", "~> 1.11"
gem "turbolinks",   "~> 5"
gem "webpacker",    "~> 4.0"

gem "bootsnap", ">= 1.4.2", require: false

gem "aleph_api", "~> 0.3.0", path: "vendor/gems/aleph_api"

group :production do
  gem "newrelic_rpm", ">= 4.5.0"
end

group :development, :test do
  gem "pry-byebug", ">= 3.9", platform: :mri
  gem "pry-rails",  ">= 0.3", platform: :mri
  gem "scout_apm",  ">= 2.6"
end

group :development do
  gem "capistrano",           "~> 3.11"
  gem "capistrano-bundler",   "~> 1.6.0"
  gem "capistrano-passenger", "~> 0.2.0"
  gem "capistrano-rails",     "~> 1.4.0"
  gem "capistrano-rvm",       "~> 0.1.2"
  gem "listen",               ">= 3.0.5", "< 3.2"
  gem "web-console",          ">= 3.3.0"
end
