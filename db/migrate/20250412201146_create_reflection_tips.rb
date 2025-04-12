class CreateReflectionTips < ActiveRecord::Migration[8.0]
  def change
    create_table :reflection_tips do |t|
      t.string :word
      t.string :category
      t.text :tip

      t.timestamps
    end
  end
end
