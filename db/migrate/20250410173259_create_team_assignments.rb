class CreateTeamAssignments < ActiveRecord::Migration[7.1]
  def change
    create_table :team_assignments do |t|
      t.references :leader, null: false, foreign_key: { to_table: :users }
      t.references :individual, null: false, foreign_key: { to_table: :users }
      t.timestamps
    end
  end
end
