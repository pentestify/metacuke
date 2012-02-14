
RSpec::Matchers.define :contain_host do |host|
  match do |expected_hosts|
    @host = host
    expected_hosts.include? @host.addr.to_s
  end

  failure_message_for_should do |expected_hosts|
    "didn't see #{@host.addr} in #{expected_hosts}"
  end

  failure_message_for_should_not do |expected_hosts|
    "didn't expect to see #{@host.addr} in #{expected_hosts}"
   end
  
end
