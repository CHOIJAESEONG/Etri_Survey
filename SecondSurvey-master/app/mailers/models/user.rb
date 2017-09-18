class User < ApplicationRecord
  validates :sUserID, presence: true, length: {maximum: 20}
	
  has_secure_password
  validates :password, presence: true, on: :create
	
  # Returns the hash digest of the given string.
  def User.digest(string)
	cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
	                                                  BCrypt::Engine.cost
	BCrypt::Password.create(string, cost: cost)
  end
  
  validates :birthday, presence: true, on: :create
  validates :phone, presence: true, on: :create
  validates :sex, presence: true, on: :create
  validates :married, presence: true, on: :create
  validates :children, presence: true, on: :create
  validates :job, presence: true, on: :create
  validates :company, presence: true, on: :create
  validates :hobby, presence: true, on: :create
  
  has_one :filtering
end
