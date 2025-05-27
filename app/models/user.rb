# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  email           :string
#  password        :string
#  password_digest :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#
class User < ApplicationRecord

  has_secure_password


  
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true
  
  has_many :saved_dates, dependent: :destroy
  has_many :date_ideas, through: :saved_dates
end
