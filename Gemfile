# frozen_string_literal: true

source "https://rubygems.org"

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

# Specify your gem's dependencies in yabeda-rails.gemspec
gemspec

rails_version = ENV.fetch("RAILS_VERSION", "~> 7.0")
case rails_version
when "HEAD"
  git "https://github.com/rails/rails.git" do
    gem "rails"
    gem "activesupport"
    gem "railties"
  end
else
  rails_version = "~> #{rails_version}.0" if rails_version.match?(/^\d+\.\d+$/)
  gem "rails", rails_version
  gem "activesupport", rails_version
  gem "railties", rails_version
end

group :development, :test do
  gem "yabeda", "~> 0.11" # Test helpers
  gem "rspec-rails"

  gem "debug"

  gem "rubocop", "~> 1.8"
  gem "rubocop-rspec"
end
