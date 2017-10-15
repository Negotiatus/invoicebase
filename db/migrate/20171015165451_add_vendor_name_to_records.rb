class AddVendorNameToRecords < ActiveRecord::Migration[5.1]
  def change
  	add_column :internal_records, :vendor_name, :string
  	add_column :external_records, :vendor_name, :string
  end
end
