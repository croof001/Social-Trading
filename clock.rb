require 'clockwork'
$: << File.dirname(__FILE__)
require 'config/boot'
require 'config/environment'
module Clockwork
every(10.minutes, 'fetch.all.tweets') { Tweet.fetch_all }
end