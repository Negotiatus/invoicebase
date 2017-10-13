class Guess < ApplicationRecord
  belongs_to :internal_record
  belongs_to :external_record
end
