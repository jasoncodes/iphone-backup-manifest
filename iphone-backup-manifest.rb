#!/usr/bin/env ruby

require 'pathname'
ENV['BUNDLE_GEMFILE'] ||= (Pathname.new(__FILE__).realpath.dirname + 'Gemfile').to_s
$:.unshift (Pathname.new(__FILE__).realpath.dirname + 'lib').to_s

require 'rubygems'
require 'bundler'
Bundler.require

$:.unshift File.dirname(__FILE__) + '/lib'
require 'iphone_backup_manifest'

manifest = read_iphone_backup_manifest

manifest.each do |key,data|
  puts "#{key}\t#{data.domain}\t#{data.path}"
end
