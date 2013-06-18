require 'spec_helper'

describe Clinic do
	context "field validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :phone }
    it { should validate_presence_of :work_from_time }
    it { should validate_presence_of :work_to_time }
    it { should validate_presence_of :address }
  end
end
