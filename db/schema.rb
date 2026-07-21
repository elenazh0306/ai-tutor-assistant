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

ActiveRecord::Schema[8.1].define(version: 2026_07_21_123051) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "chats", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "feedback_id"
    t.bigint "subject_id", null: false
    t.string "title"
    t.datetime "updated_at", null: false
    t.index ["feedback_id"], name: "index_chats_on_feedback_id"
    t.index ["subject_id"], name: "index_chats_on_subject_id"
  end

  create_table "feedbacks", force: :cascade do |t|
    t.text "content"
    t.datetime "created_at", null: false
    t.bigint "test_id", null: false
    t.datetime "updated_at", null: false
    t.index ["test_id"], name: "index_feedbacks_on_test_id"
  end

  create_table "materials", force: :cascade do |t|
    t.string "content"
    t.datetime "created_at", null: false
    t.bigint "subject_id", null: false
    t.string "title"
    t.datetime "updated_at", null: false
    t.index ["subject_id"], name: "index_materials_on_subject_id"
  end

  create_table "messages", force: :cascade do |t|
    t.bigint "chat_id", null: false
    t.text "content"
    t.datetime "created_at", null: false
    t.string "role"
    t.datetime "updated_at", null: false
    t.index ["chat_id"], name: "index_messages_on_chat_id"
  end

  create_table "questions", force: :cascade do |t|
    t.text "answer"
    t.datetime "created_at", null: false
    t.bigint "test_id", null: false
    t.string "title"
    t.datetime "updated_at", null: false
    t.index ["test_id"], name: "index_questions_on_test_id"
  end

  create_table "subjects", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.bigint "tutor_id", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["tutor_id"], name: "index_subjects_on_tutor_id"
    t.index ["user_id"], name: "index_subjects_on_user_id"
  end

  create_table "tests", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "material_id", null: false
    t.string "title"
    t.datetime "updated_at", null: false
    t.index ["material_id"], name: "index_tests_on_material_id"
  end

  create_table "tutors", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "chats", "feedbacks"
  add_foreign_key "chats", "subjects"
  add_foreign_key "feedbacks", "tests"
  add_foreign_key "materials", "subjects"
  add_foreign_key "messages", "chats"
  add_foreign_key "questions", "tests"
  add_foreign_key "subjects", "tutors"
  add_foreign_key "subjects", "users"
  add_foreign_key "tests", "materials"
end
