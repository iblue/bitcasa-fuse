# Load gems from Gemfile
require 'rubygems'
require 'bundler'

Bundler.require

# Load local stuff
require './lib/bitcasa/session.rb'
require './lib/bitcasa/fuse.rb'


# Login
require "./my-password.rb"
puts "Logging in..."
session = Bitcasa::Session.new(IBLUE_USERNAME, IBLUE_PASSWORD)
puts "Initializing file system..."
fuse    = Bitcasa::Fuse.new(session)

if ARGV.length == 0
  print "\n"
  print "Usage: [ruby [--debug]] #{$0} mountpoint [mount_options...]\n"
  print "\n"
  print "   mountpoint must be an existing directory\n"
  print "   mount_option '-h' will list supported options\n"
  print "\n"
  print "   For verbose debugging output use --debug to ruby\n"
  print "   and '-odebug' as mount_option\n"
  print "\n"
  exit(1)
end

fo = RFuse::FuseDelegator.new(fuse, *ARGV)

if fo.mounted?
  Signal.trap("TERM") { print "Caught TERM\n" ; fo.exit }
  Signal.trap("INT") { print "Caught INT\n"; fo.exit }

  begin
    fo.loop
  rescue
    print "Error:" + $!
  ensure
    fo.unmount if fo.mounted?
    print "Unmounted #{ARGV[0]}\n"
  end
end
