class CreateSurveysAndDetails < ActiveRecord::Migration[8.1]
  def change
    create_table :surveys do |t|
      t.references :teacher, null: false, foreign_key: { to_table: :users }
      t.references :student_course, null: false, foreign_key: true
      t.timestamps
    end

    create_table :survey_details do |t|
      t.references :survey, null: false, foreign_key: true
      t.integer :quality_of_classes_conducted, null: false
      t.integer :ease_of_communication, null: false
      t.integer :fair_and_clear_conditions, null: false
      t.text :detailed_opinion
      t.timestamps
    end

    add_index :surveys, :teacher_id unless index_exists?(:surveys, :teacher_id)
    add_index :surveys, :student_course_id unless index_exists?(:surveys, :student_course_id)
  end
end
