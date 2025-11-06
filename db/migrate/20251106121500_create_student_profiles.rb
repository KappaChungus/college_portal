class CreateStudentProfiles < ActiveRecord::Migration[8.1]
  def change
    create_table :student_profiles do |t|
      t.references :user, null: false, foreign_key: { to_table: :users }
      t.string :study_name
      t.integer :study_year
      t.string :semester
      t.string :specialization_field

      t.timestamps
    end

    # add unique index on user_id if it doesn't already exist (protect against partial/previous runs)
    unless index_exists?(:student_profiles, :user_id)
      add_index :student_profiles, :user_id, unique: true
    end
  end
end
