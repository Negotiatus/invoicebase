class CreateExternalRecords < ActiveRecord::Migration[5.1]
  def change
    create_table :external_records do |t|
      t.string     :invoice_number
      t.string     :reference_number
      t.string     :negotiatus_reference_number
      t.date       :date
      t.integer    :amount_cents
      t.string     :delivery_address_string
      t.string     :delivery_address_zipcode
      t.integer    :reconciliation_id
      t.datetime   :paid_at
      t.boolean    :payable

      t.timestamps
    end

    add_index :external_records, :date
    add_index :external_records, [:paid_at, :payable]
  end
end
