class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, 
    :user_profile_attributes
  # attr_accessible :title, :body

  belongs_to :user_role
  has_one :user_profile, :dependent => :destroy
  delegate :name, :gender, :date_of_birth, :age, :phone, :address,
    :to => :user_profile  
    
  accepts_nested_attributes_for :user_profile, :allow_destroy => true

  validates :user_role_id, :presence => true, :numericality => true

  def admin?
    user_role.name == "admin"
  end

  def patient?
    user_role.name == "patient"
  end

  def practitioner?
    user_role.name == "practitioner"
  end

  def staff?
    user_role.name == "staff"
  end

  def managing_director?
    user_role.name == "managing_director"
  end

  def supplier?
    user_role.name == "supplier"
  end
end
