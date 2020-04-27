lock "~> 3.11"

set :application, "covid19_access"
set :repo_url, "git@github.com:ubpb/covid19_access.git"
set :branch, "master"
set :log_level, :debug

append :linked_files, "config/database.yml", "config/master.key", "config/application.yml"
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"

set :rvm_type, :user
set :rvm_ruby_version, IO.read(".ruby-version").strip

set :passenger_roles, :web

set :rails_env, "production"
