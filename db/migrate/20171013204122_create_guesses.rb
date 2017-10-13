class CreateGuesses < ActiveRecord::Migration[5.1]
  def change
    create_table :guesses do |t|
      t.references :external_record
      t.references :internal_record

      t.timestamps
    end
  end
end
