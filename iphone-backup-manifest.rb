#!/usr/bin/env ruby

$:.unshift File.dirname(__FILE__) + '/lib'
require 'rubygems'
require 'iphone_backup_manifest'

manifest = read_iphone_backup_manifest

manifest.each do |key,data|
  puts "#{key}\t#{data.domain}\t#{data.path}"
end
