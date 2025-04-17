class AddExampleToUnmatchedKeywords < ActiveRecord::Migration[8.0]
  def change
    add_column :unmatched_keywords, :example, :text
  end
end
