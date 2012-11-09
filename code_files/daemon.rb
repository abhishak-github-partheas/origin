require 'rubygems'        # if you use RubyGems
require 'daemons'

options = {
   :ARGV       => [ARGV[0],'--',ARGV[1]]
}
Daemons.run(File.join(File.dirname(__FILE__), 'holyplan.rb'), options)