class CreateUnmatchedKeywords < ActiveRecord::Migration[8.0]
  def change
    create_table :unmatched_keywords do |t|
      t.string :word
      t.string :category
      t.integer :count

      t.timestamps
    end
  end
end
