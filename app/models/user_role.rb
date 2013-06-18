class UserRole < ActiveRecord::Base
  attr_accessible :name

  def self.user_role_id(obj)
  	return find_by_name("admin").id if obj.is_a?(Admin)
  	return find_by_name("practitioner").id if obj.is_a?(Practitioner)
  	return find_by_name("patient").id if obj.is_a?(Patient)
		return find_by_name("staff").id if obj.is_a?(Staff)
		return find_by_name("managing_director").id if obj.is_a?(ManagingDirector)
		return find_by_name("supplier").id if obj.is_a?(Supplier)
		nil
  end
end
