# config valid only for Capistrano 3.1
lock '3.1.0'

set :application, 'SafeFare'
set :deploy_user, 'deployer'
set :repo_url, 'ssh://git@office.themechanism.com/volume1/homes/git/repositories/safeFare.git'
set :ssh_options, { :forward_agent => true }

# Default branch is :master
set :branch, 'master'

# Default deploy_to directory is /var/www/my_app
 set :deploy_to, '/var/www/safeFare'

# Default value for :scm is :git
 set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty
set :rails_env, "production"
# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
#set :pty, true

# Default value for :linked_files is []
set :linked_files, %w{config/database.yml config/database.yml}

# Default value for linked_dirs is []
set :linked_dirs, %w{bin log tmp vendor/bundle public/system}

# Default value for default_env is {}
#set :default_env, { path: "/opt/ruby/bin:$PATH" }
set :default_env, { rvm_bin_path: '/home/deployer/.rvm/bin/rvm' }

SSHKit.config.command_map[:rake]  = " RAILS_ENV=production bundle exec rake" #8
SSHKit.config.command_map[:rails] = "bundle exec rails"

# Default value for keep_releases is 5
 set :keep_releases, 5

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
       execute :touch, release_path.join('tmp/restart.txt')
       
    end
  end

  after :finishing, "deploy:cleanup"

  
  
  # after :publishing, :restart

  # after :restart, :clear_cache do
  #   on roles(:web), in: :groups, limit: 3, wait: 10 do
  #     # Here we can do anything such as:
  #     # within release_path do
  #     #   execute :rake, 'cache:clear'
  #     # end
  #   end
  # end

end
