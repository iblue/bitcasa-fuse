# Load gems from Gemfile
require 'rubygems'
require 'bundler'

Bundler.require

# Load local stuff
require './lib/bitcasa/session.rb'

# Login
require "./my-password.rb"
session = Bitcasa::Session.new(IBLUE_USERNAME, IBLUE_PASSWORD)
