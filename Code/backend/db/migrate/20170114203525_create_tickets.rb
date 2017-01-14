class CreateTickets < ActiveRecord::Migration[5.0]
  def change
    create_table :tickets do |t|
      t.string :title
      t.string :body
      t.string :status
      t.references :author, foreign_key: {to_table: :users}

      t.timestamps
    end
    add_index :tickets, :status
  end
end
