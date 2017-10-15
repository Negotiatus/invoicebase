class AddConfidenceToGuesses < ActiveRecord::Migration[5.1]
  def change
    add_column :guesses, :confidence, :float, default: 0.0
  end
end
