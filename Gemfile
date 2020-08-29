# frozen_string_literal: true

source 'https://rubygems.org'

# The bare minimum for building, e.g. in Homebrew
group :build do
  gem 'rake', '~> 13.0'
  gem 'xcpretty'
end

# In addition to :build, for contributing
group :development do
  gem 'cocoapods', '~> 1.9.0'
  gem 'danger'
  gem 'rubocop', '~> 0.80'
end

# For releasing to GitHub
group :release do
  gem 'octokit', '~> 4.16'
  gem 'plist', '~> 3.5'
end
