#!/usr/bin/ruby
#

require 'fileutils'
require 'nmap/parser'

env = ARGV[0]
range = ARGV[1].split(",")

puts "Configuring environment: #{env}"
puts "Using range: #{range}"

nmap_output_path = "/tmp/nmap_network_audit_#{rand(10000)}.xml"
nmap_command_line = "nmap -oX #{nmap_output_path} #{range.join(" ")}"


`#{nmap_command_line}`

data_path = File.join(File.dirname(__FILE__), "..", "data")
env_path = File.join(data_path, env)

FileUtils.mkdir(env_dir) unless File.directory? env_path
FileUtils.mkdir(env_dir) unless File.directory? data_path

f = File.open(File.join(env_path, "known_systems.txt"),"w")

parser = Nmap::Parser.parsefile(nmap_output_path)

parser.hosts("up").each do |host|
  puts "found host #{host.addr}"
  f.puts host.addr
end

puts "done."
