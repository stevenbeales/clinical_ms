class GenerateDefaultUserRoles < ActiveRecord::Migration
  def up
  	# add roles to user
  	UserRole.new(:name => "admin").save
  	UserRole.new(:name => "practitioner").save
  	UserRole.new(:name => "patient").save
		UserRole.new(:name => "staff").save
  	UserRole.new(:name => "managing_director").save
  	UserRole.new(:name => "supplier").save
  end

  def down
  	# not reversible, roles are fixed and service's ability is defined on it
  end
end
