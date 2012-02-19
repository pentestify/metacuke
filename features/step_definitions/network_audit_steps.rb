#  6   Scenario: Identify unknown systems
#  7     Given I have a list of known systems on the production net
#  8     When I scan for new systems on the production net·
#  9     Then I should have 0 new systems

World(MetacukeWorld)

  Given /^I have a list of known systems on the (.+) net$/ do |named_list|
    #
    # Grab the known systems from our data directory
    # 
    @systems = File.open(File.join(MetacukeWorld::Metadata.new.files,named_list,"known_systems.txt")).read.split("\n")
  end
  
  When /^I scan for new systems on the (.+) net$/ do |named_list|
    #
    # Grab the known networks from our data directory
    # 
    @nets = File.open(File.join(MetacukeWorld::Metadata.new.files,named_list,"known_nets.txt")).read.split("\n")

    #
    # Set up the nmap command line
    #
    @nmap_output_path = "/tmp/nmap_network_audit_#{rand(10000)}.xml"
    nmap_command_line = "nmap -oX #{@nmap_output_path} "

    #
    # Build the nmap string, adding each net in turn
    #
    nmap_command_line << @nets.join(" ")
    
    # execute the nmap string:
    `#{nmap_command_line}`
  end
  
  Then /I should have (.+) new systems/ do |num|
    #
    # Parse the nmap scan, and see if we have anything left 
    #
    parser = Nmap::Parser.parsefile(@nmap_output_path)
    parser.hosts("up").each do |host|
       puts "checking host #{host.addr}"
       @systems.should contain_host host
    end
  end
