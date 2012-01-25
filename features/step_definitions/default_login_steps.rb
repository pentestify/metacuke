World(MetacukeWorld)

Given /^I have a list of (.+) systems$/ do |named_list|
		@systems = File.open(File.join(Metadata.new.files,"#{named_list}_systems.txt")).read
end

Given /^I have a list of (.+) usernames$/ do |named_list|
		@usernames = File.open(File.join(Metadata.new.files,"#{named_list}_usernames.txt")).read
end

Given /^I have a list of (.+) passwords$/ do |named_list|
	@passwords = File.open(File.join(Metadata.new.files,"#{named_list}_passwords.txt")).read
end

When /^I run the (.+) module$/ do |module_names|
	module_list = module_names.split(",")
	module_list.each do |mod|
			run_module(mod, @systems)
	end
end

When /^I run the (.+) module with options (.+)$/ do |module_names,options|
	module_list = module_names.split(",")
	module_list.each do |mod|
			run_module(mod, @systems, options)
	end
end
	
When /^I check for valid logins via (.+)$/ do |types|
	types = types.split(",")
	types.each do |type| 
		check_logins(type, @systems,@usernames,@passwords)
	end
end

Then /^I should have (.+) sessions$/ do |count| 
	get_session_count.should == count.to_i
end

Then /^I should have (.+) valid logins$/ do |count| 
	get_valid_cred_count.should == count.to_i
end
