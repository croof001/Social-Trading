echo "Switching to application directory"
cd /home/social
echo "Stopping nginx"
service nginx stop
echo "Stopping delayed jobs"
RAILS_ENV=production bin/delayed_job stop
echo "stopping thin servers"
thin stop --servers 3
rm -r public/assets
echo "Cleaning every local change"
git reset --hard origin/master
echo "fetching latest code"
git pull 
echo "running bundle install"
bundle install
echo "Resetting production database"
RAILS_ENV=production rake db:reset
echo "running migrations is production"
RAILS_ENV=production rake db:migrate
echo "starting three nginx servrs"
thin start --servers 3 -e production
echo "starting delayed jobs"
RAILS_ENV=production bin/delayed_job --queues=keyword_fetch,auto_x start
echo "re-starting nginx"
service nginx restart
echo "pre-compiling assets in productiom"
RAILS_ENV=production rake assets:precompile
echo "start clockwork"
#RAILS_ENV=production  clockwork clock.rb
RAILS_ENV=production clockworkd -c clock.rb start