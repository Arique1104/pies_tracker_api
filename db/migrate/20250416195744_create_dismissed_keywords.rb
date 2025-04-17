class CreateDismissedKeywords < ActiveRecord::Migration[8.0]
  def change
    create_table :dismissed_keywords do |t|
      t.string :word

      t.timestamps
    end
    add_index :dismissed_keywords, :word, unique: true
  end
end
