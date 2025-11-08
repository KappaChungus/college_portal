# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2025_11_08_202351) do
  create_table "announcements", force: :cascade do |t|
    t.text "content", null: false
    t.datetime "created_at", null: false
    t.date "date", null: false
    t.integer "teacher_id", null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.index ["date"], name: "index_announcements_on_date"
    t.index ["teacher_id"], name: "index_announcements_on_teacher_id"
  end

  create_table "course_teachers", force: :cascade do |t|
    t.integer "course_id", null: false
    t.datetime "created_at", null: false
    t.integer "teacher_id", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_course_teachers_on_course_id"
    t.index ["teacher_id"], name: "index_course_teachers_on_teacher_id"
  end

  create_table "courses", force: :cascade do |t|
    t.string "code"
    t.datetime "created_at", null: false
    t.integer "group_id"
    t.integer "teacher_id"
    t.string "title"
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_courses_on_group_id"
  end

  create_table "groups", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
  end

  create_table "petitions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "petition_content", null: false
    t.string "status", default: "pending", null: false
    t.integer "student_id", null: false
    t.string "topic", null: false
    t.datetime "updated_at", null: false
    t.index ["student_id"], name: "index_petitions_on_student_id"
  end

  create_table "schedules", force: :cascade do |t|
    t.integer "course_id", null: false
    t.datetime "created_at", null: false
    t.integer "day_of_week", null: false
    t.time "end_time", null: false
    t.integer "group_id", null: false
    t.string "room"
    t.time "start_time", null: false
    t.integer "teacher_id"
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_schedules_on_course_id"
    t.index ["group_id", "day_of_week", "start_time"], name: "index_schedules_on_group_day_start"
    t.index ["group_id"], name: "index_schedules_on_group_id"
    t.index ["teacher_id"], name: "index_schedules_on_teacher_id"
  end

  create_table "student_courses", force: :cascade do |t|
    t.integer "course_id", null: false
    t.datetime "created_at", null: false
    t.float "final_grade"
    t.json "grades", default: []
    t.string "group_code"
    t.boolean "rated", default: false, null: false
    t.boolean "retaken", default: false
    t.string "status", default: "current", null: false
    t.integer "student_id", null: false
    t.integer "teacher_id"
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_student_courses_on_course_id"
    t.index ["rated"], name: "index_student_courses_on_rated"
    t.index ["student_id"], name: "index_student_courses_on_student_id"
    t.index ["teacher_id"], name: "index_student_courses_on_teacher_id"
  end

  create_table "student_profiles", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "semester"
    t.string "specialization_field"
    t.string "study_name"
    t.integer "study_year"
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_student_profiles_on_user_id"
  end

  create_table "survey_details", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "detailed_opinion"
    t.integer "ease_of_communication", null: false
    t.integer "fair_and_clear_conditions", null: false
    t.integer "quality_of_classes_conducted", null: false
    t.integer "survey_id", null: false
    t.datetime "updated_at", null: false
    t.index ["survey_id"], name: "index_survey_details_on_survey_id"
  end

  create_table "surveys", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "student_course_id", null: false
    t.integer "teacher_id", null: false
    t.datetime "updated_at", null: false
    t.index ["student_course_id"], name: "index_surveys_on_student_course_id"
    t.index ["teacher_id"], name: "index_surveys_on_teacher_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email"
    t.string "encrypted_password", default: "", null: false
    t.string "name"
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.string "science_title"
    t.string "type"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "announcements", "users", column: "teacher_id"
  add_foreign_key "course_teachers", "courses"
  add_foreign_key "course_teachers", "users", column: "teacher_id"
  add_foreign_key "courses", "groups"
  add_foreign_key "petitions", "users", column: "student_id"
  add_foreign_key "schedules", "courses"
  add_foreign_key "schedules", "groups"
  add_foreign_key "schedules", "users", column: "teacher_id"
  add_foreign_key "student_courses", "courses"
  add_foreign_key "student_courses", "users", column: "student_id"
  add_foreign_key "student_courses", "users", column: "teacher_id"
  add_foreign_key "student_profiles", "users"
  add_foreign_key "survey_details", "surveys"
  add_foreign_key "surveys", "student_courses"
  add_foreign_key "surveys", "users", column: "teacher_id"
end
