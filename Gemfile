require 'open3'
source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.2.1"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.0.4", ">= 7.0.4.3"

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "sprockets-rails"

# Use sqlite3 as the database for Active Record
gem "sqlite3", "~> 1.4"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", "~> 5.0"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]

gem 'hotwire-rails'
gem "devise"
gem "image_processing", '~> 1.2'
gem "mini_magick"
gem "redis"

unless system("which redis-server > /dev/null 2>&1")
    puts "Instalando o redis-server..."
    stdout, stderr, status = Open3.capture3("sudo apt-get install redis-server")
    puts stdout
    puts stderr
    raise "Erro ao instalar o redis-server" unless status.success?
end

unless system("which google-chrome-stable > /dev/null 2>&1")
  puts "Instalando o Google Chrome..."
  

  system("wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb")

  Open3.popen3("sudo dpkg -i google-chrome-stable_current_amd64.deb") do |stdin, stdout, stderr, wait_thr|
    puts stdout.read
    puts stderr.read
    raise "Erro ao instalar o Google Chrome" unless wait_thr.value.success?
  end
  
  system("sudo apt install -f")
  File.delete("google-chrome-stable_current_amd64.deb")
end

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
  gem "rspec-rails"
  gem "capybara"
  gem 'selenium-webdriver'
  gem 'webdrivers'
end

group :development do
  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
end


gem "importmap-rails", "~> 1.1"

# Use Redis for Action Cable

