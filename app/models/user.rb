# == Schema Information
#
# Table name: users
#
#  id                  :integer          not null, primary key
#  first_name          :string           not null
#  last_name           :string           not null
#  provider            :string           not null
#  uid                 :string           not null
#  image               :string
#  email               :string           not null
#  remember_created_at :datetime
#  sign_in_count       :integer          default(0), not null
#  current_sign_in_at  :datetime
#  last_sign_in_at     :datetime
#  current_sign_in_ip  :inet
#  last_sign_in_ip     :inet
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class User < ApplicationRecord
  devise :registerable, :rememberable, :trackable,
         :omniauthable, omniauth_providers: [:google_oauth2]

  has_many :validations

  def self.from_omniauth(access_token)
    where(
      provider: access_token.provider,
      uid:      access_token.uid
    ).first_or_create! do |user|
      if !(access_token.info.email =~ /@negotiatus.com$/)
        raise User::InvalidDomainError, "Must be a Negotiatus employee"
      end

      user.email      = access_token.info.email
      user.first_name = access_token.info.first_name
      user.last_name  = access_token.info.last_name
      user.image      = access_token.info.image
    end
  end

  def name
    "#{first_name} #{last_name[0]}."
  end

  def encrypted_password
    false
  end

  class InvalidDomainError < StandardError
  end
end
