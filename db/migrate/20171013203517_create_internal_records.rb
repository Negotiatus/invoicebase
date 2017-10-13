class CreateInternalRecords < ActiveRecord::Migration[5.1]
  def change
    create_table :internal_records do |t|
      t.string     :reference_number
      t.string     :negotiatus_reference_number
      t.date       :date
      t.integer    :amount_cents
      t.string     :delivery_address_string
      t.string     :delivery_address_zipcode

      t.timestamps
    end
  end
end
