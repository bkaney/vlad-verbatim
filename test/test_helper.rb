require 'rubygems'
require 'test/unit'
require 'shoulda'
require 'mocha'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib', 'vlad'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'vlad'
require 'verbatim'
require 'config/deploy'

include Vlad::Verbatim

class Test::Unit::TestCase
  def template
    File.read(File.dirname(__FILE__) + "/config/target/etc/booga.conf.erb")
  end
end
