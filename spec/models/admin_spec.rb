require 'spec_helper'

describe Admin do
	context "user role" do
		it "is set to Admin role on validation" do
			admin = Admin.new
			admin.valid?
			admin.user_role.name.should == "admin"
		end
	end
end
