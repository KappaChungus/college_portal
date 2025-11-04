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

ActiveRecord::Schema[8.1].define(version: 2025_11_04_135906) do
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

  create_table "enrollments", force: :cascade do |t|
    t.integer "course_id", null: false
    t.datetime "created_at", null: false
    t.string "grade"
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["course_id"], name: "index_enrollments_on_course_id"
    t.index ["user_id"], name: "index_enrollments_on_user_id"
  end

  create_table "groups", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
  end

  create_table "student_courses", force: :cascade do |t|
    t.integer "course_id", null: false
    t.datetime "created_at", null: false
    t.float "final_grade"
    t.json "grades", default: []
    t.string "group_code"
    t.boolean "retaken", default: false
    t.string "status", default: "current", null: false
    t.integer "student_id", null: false
    t.integer "teacher_id"
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_student_courses_on_course_id"
    t.index ["student_id"], name: "index_student_courses_on_student_id"
    t.index ["teacher_id"], name: "index_student_courses_on_teacher_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email"
    t.string "encrypted_password", default: "", null: false
    t.integer "group_id"
    t.string "name"
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.string "type"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["group_id"], name: "index_users_on_group_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "course_teachers", "courses"
  add_foreign_key "course_teachers", "users", column: "teacher_id"
  add_foreign_key "courses", "groups"
  add_foreign_key "enrollments", "courses"
  add_foreign_key "enrollments", "users"
  add_foreign_key "student_courses", "courses"
  add_foreign_key "student_courses", "users", column: "student_id"
  add_foreign_key "student_courses", "users", column: "teacher_id"
  add_foreign_key "users", "groups"
end
