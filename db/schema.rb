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

ActiveRecord::Schema[7.0].define(version: 2023_05_19_020401) do
  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.integer "record_id", null: false
    t.integer "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.integer "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "answers", force: :cascade do |t|
    t.string "content"
    t.integer "doubt_id", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["doubt_id"], name: "index_answers_on_doubt_id"
    t.index ["user_id"], name: "index_answers_on_user_id"
  end

  create_table "batch_items", force: :cascade do |t|
    t.integer "batch_id", null: false
    t.integer "item_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["batch_id"], name: "index_batch_items_on_batch_id"
    t.index ["item_id"], name: "index_batch_items_on_item_id"
  end

  create_table "batches", force: :cascade do |t|
    t.string "code"
    t.date "start_date"
    t.date "end_date"
    t.decimal "minimum_bid_difference"
    t.integer "created_by_id", null: false
    t.integer "approved_by_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "minimum_bid"
    t.integer "end_status", default: 0
    t.index ["approved_by_id"], name: "index_batches_on_approved_by_id"
    t.index ["created_by_id"], name: "index_batches_on_created_by_id"
  end

  create_table "bids", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "batch_id", null: false
    t.decimal "amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["batch_id"], name: "index_bids_on_batch_id"
    t.index ["user_id"], name: "index_bids_on_user_id"
  end

  create_table "blocked_cpfs", force: :cascade do |t|
    t.integer "cpf"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "doubts", force: :cascade do |t|
    t.string "content"
    t.integer "user_id", null: false
    t.integer "batch_id", null: false
    t.boolean "visible", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "answered", default: false
    t.index ["batch_id"], name: "index_doubts_on_batch_id"
    t.index ["user_id"], name: "index_doubts_on_user_id"
  end

  create_table "item_categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "items", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.integer "weight"
    t.integer "width"
    t.integer "height"
    t.integer "depth"
    t.integer "item_category_id", null: false
    t.string "registration_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_category_id"], name: "index_items_on_item_category_id"
  end

  create_table "user_favorite_batches", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "batch_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["batch_id"], name: "index_user_favorite_batches_on_batch_id"
    t.index ["user_id"], name: "index_user_favorite_batches_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "name", null: false
    t.string "cpf", null: false
    t.boolean "admin", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "blocked_cpf_id"
    t.index ["blocked_cpf_id"], name: "index_users_on_blocked_cpf_id"
    t.index ["cpf"], name: "index_users_on_cpf", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "answers", "doubts"
  add_foreign_key "answers", "users"
  add_foreign_key "batch_items", "batches"
  add_foreign_key "batch_items", "items"
  add_foreign_key "batches", "users", column: "approved_by_id"
  add_foreign_key "batches", "users", column: "created_by_id"
  add_foreign_key "bids", "batches"
  add_foreign_key "bids", "users"
  add_foreign_key "doubts", "batches"
  add_foreign_key "doubts", "users"
  add_foreign_key "items", "item_categories"
  add_foreign_key "user_favorite_batches", "batches"
  add_foreign_key "user_favorite_batches", "users"
  add_foreign_key "users", "blocked_cpfs"
end
