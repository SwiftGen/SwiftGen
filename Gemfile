# frozen_string_literal: true

source 'https://rubygems.org'

# The bare minimum for building, e.g. in Homebrew
group :build do
  gem 'rake', '~> 13.0'
  gem 'xcpretty', '~> 0.3'
end

# In addition to :build, for contributing
group :development do
  gem 'cocoapods', '~> 1.11.0'
  gem 'danger', '~> 8.4'
  gem 'rubocop', '~> 1.22'
end

# For releasing to GitHub
group :release do
  gem 'octokit', '~> 4.7'
  gem 'plist', '~> 3.6'
end
