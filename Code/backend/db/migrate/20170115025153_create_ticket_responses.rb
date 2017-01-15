class CreateTicketResponses < ActiveRecord::Migration[5.0]
  def change
    create_table :ticket_responses do |t|
      t.text :body
      t.references :ticket, foreign_key: true
      t.references :author, foreign_key: {to_table: :users}

      t.timestamps
    end
  end
end
