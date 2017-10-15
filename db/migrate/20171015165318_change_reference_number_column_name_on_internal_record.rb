class ChangeReferenceNumberColumnNameOnInternalRecord < ActiveRecord::Migration[5.1]
  def change
  	rename_column :internal_records, :reference_number, :external_reference_number
  end
end
