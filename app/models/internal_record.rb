class InternalRecord < ApplicationRecord
  has_many :guesses

  validates_presence_of :reference_number, :negotiatus_reference_number, :delivery_address_string, :delivery_address_zipcode, :amount_cents, :date
end
