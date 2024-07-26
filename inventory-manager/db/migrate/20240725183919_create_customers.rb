class CreateCustomers < ActiveRecord::Migration[7.1]
  def up
    enable_extension("citext")

    create_table :customers do |t|
      t.string :name, null: false
      t.citext :email, null: false
      t.references :store, null: false, foreign_key: true
      t.references :model, null: false, foreign_key: true

      t.timestamps
    end

    add_index :customers, %i[email store_id model_id], unique: true
  end

  def down
    remove_index :customers, name: :index_customers_on_email_and_store_id_and_model_id
    drop_table :customers
    disable_extension "citext"
  end
end
