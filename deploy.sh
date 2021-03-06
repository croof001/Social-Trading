echo "Switching to application directory"
cd /home/social
echo "Stopping nginx"
service nginx stop
echo "Stopping delayed jobs"
RAILS_ENV=production bin/delayed_job stop
echo "stopping thin servers"
thin stop --servers 3
echo "Stoping clockwork scheduler"
kill -KILL $(cat tmp/clock.pid)
echo "Clearing assets"
rm -r public/assets
echo "Cleaning every local change"
git reset --hard origin/master
echo "fetching latest code"
git pull 
echo "running bundle install"
bundle install
echo "Resetting production database"
RAILS_ENV=production rake db:drop
RAILS_ENV=production rake db:create
echo "running migrations is production"
RAILS_ENV=production rake db:migrate
echo "seeding"
RAILS_ENV=production rake db:seed
echo "pre-compiling assets in productiom"
RAILS_ENV=production rake assets:precompile
echo "starting three thin servrs"
thin start --servers 3 -e production
echo "starting delayed jobs"
RAILS_ENV=production bin/delayed_job --queues=keyword_fetch,auto_x,stream_fetch,notifications start
echo "re-starting nginx"
service nginx restart

echo "start clockwork"
#RAILS_ENV=production  clockwork clock.rb
#RAILS_ENV=production clockworkd -c clock.rb start
RAILS_ENV=production nohup clockwork clock.rb  0<&- &> tmp/clock.log & echo $! > tmp/clock.pid