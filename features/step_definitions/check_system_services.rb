#  Scenario: Check for production services
#    Given I have a list of production systems and services
#    And I scan the production systems
#    Then all services should be up

World(MetacukeWorld)

Given /^I scan the (.+) systems$/ do |named_list|
  # Gather all ports to scan
  file = File.join(Metadata.new.files,"#{named_list}_services.yml")
  puts "DEBUG: getting services from #{file}"
  system_infoz = YAML::load_file(file)

  all_ports = []
  all_systems = []
  system_infoz.each {|x| all_ports << x['tcp_services'].join(",")}
  system_infoz.each {|x| all_systems << x['ip_address']}

  `nmap -oX /tmp/#{named_list}.xml -p #{all_ports.join(",")} #{all_systems.join(", ")} `
end

Then /all (.+) services should be up/ do |named_list| 
  parser = Nmap::Parser.parsefile "/tmp/#{named_list}.xml"
  system_infoz = YAML::load_file(File.join(Metadata.new.files,"#{named_list}_services.yml"))
  
  total_count = 0
  system_infoz.each{ |x| total_count = total_count + x["tcp_services"].count }

  found_count = 0
  # Go through each known system
  system_infoz.each do |info|
    # check systems we scanned
    parser.hosts("up") do |nmap_host|
      # keep going if we have this address
      if nmap_host.ip4_addr == info['ip_address']
        puts "DEBUG: matched #{info['ip_address']}"              
        # check all known services
        info['tcp_services'].each do |service|
          nmap_host.getports(:tcp, "open").map do |x| 
            if x.num == service.to_i
              found_count += 1 
            end
          end
        end
      end
    end
  end

  found_count.should == total_count
  
  # cleanup
  `rm /tmp/#{named_list}.xml`
end
