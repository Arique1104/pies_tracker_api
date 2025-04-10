class CreatePiesEntries < ActiveRecord::Migration[8.0]
  def change
    create_table :pies_entries do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :physical
      t.text :physical_description
      t.integer :intellectual
      t.text :intellectual_description
      t.integer :emotional
      t.text :emotional_description
      t.integer :spiritual
      t.text :spiritual_description
      t.date :checked_in_on

      t.timestamps
    end
  end
end
