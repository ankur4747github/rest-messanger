class CreateSessions < ActiveRecord::Migration[5.1]
  def change
    create_table :sessions do |t|
      t.string :session_id
      t.string :email
      t.references :user
      t.timestamps
    end
  end
end
