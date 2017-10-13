class AddConfidenceToGuesses < ActiveRecord::Migration
  def change
    add_column :guesses, :confidence, :float, default: 0.0
  end
end
