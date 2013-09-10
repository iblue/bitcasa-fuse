# Load gems from Gemfile
require 'rubygems'
require 'bundler'

Bundler.require

# Load local stuff
require './lib/bitcasa/session.rb'
require './lib/bitcasa/directory.rb'

# Login
require "./my-password.rb"
puts "Logging in..."
session = Bitcasa::Session.new(USERNAME, PASSWORD)
puts "Initializing file system..."
root    = Bitcasa::Directory.new(session)

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

FuseFS.start(root, *ARGV)
