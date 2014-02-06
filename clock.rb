require 'clockwork'
$: << File.dirname(__FILE__)
require 'config/boot'
require 'config/environment'
module Clockwork
every(10.minutes, 'fetch.all.tweets') { TwitterManager.fetch_all }
end