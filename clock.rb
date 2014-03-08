
$: << File.dirname(__FILE__)
require 'config/environment'
require 'config/boot'
require 'clockwork'
module Clockwork
every(2.minutes, 'fetch.all.tweets') { TwitterManager.fetch_all(true) }
every(3.minutes, 'get.all.streams'){TwitterManager.stream_all}
every(3.minutes, 'get.all.streams'){FacebookManager.stream_all}
end
