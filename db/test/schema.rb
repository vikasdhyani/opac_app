ActiveRecord::Schema.define(:version => 20111003135157) do
  create_table "authentications", :force => true do |t|
    t.integer  "user_id",    :precision => 38, :scale => 0
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "batches", :force => true do |t|
    t.string   "batch_type"
    t.string   "assigned_to"
    t.string   "state"
    t.integer  "item_count",   :precision => 38, :scale => 0
    t.integer  "closed_count", :precision => 38, :scale => 0
    t.datetime "expires_on"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "email",                                                              :default => "", :null => false
    t.string   "encrypted_password",   :limit => 128,                                :default => "", :null => false
    t.string   "password_salt",                                                      :default => "", :null => false
    t.string   "reset_password_token"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                       :precision => 38, :scale => 0, :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["reset_password_token"], :name => "i_users_reset_password_token", :unique => true
  add_index "users", ["username"], :name => "index_users_on_username", :unique => true

  create_table "ibt_hidden_reqs", :force => true do |t|
    t.string    "category"
    t.string    "rack"
    t.string    "shelf"
    t.timestamp "created_at",    :limit => 6
    t.timestamp "updated_at",    :limit => 6
    t.integer   "respondent_id",              :precision => 38, :scale => 0
    t.integer   "title_id",                   :precision => 38, :scale => 0
  end

  create_table "ibt_hidden_reqs_bkp", :id => false, :force => true do |t|
    t.integer   "id",                         :precision => 38, :scale => 0, :null => false
    t.string    "category"
    t.string    "rack"
    t.string    "shelf"
    t.timestamp "created_at",    :limit => 6
    t.timestamp "updated_at",    :limit => 6
    t.integer   "respondent_id",              :precision => 38, :scale => 0
    t.integer   "title_id",                   :precision => 38, :scale => 0
  end

  create_table "ibt_reassigns", :force => true do |t|
    t.integer  "batch_id",      :precision => 38, :scale => 0
    t.integer  "title_id",      :precision => 38, :scale => 0
    t.integer  "ibtr_id",       :precision => 38, :scale => 0
    t.integer  "respondent_id", :precision => 38, :scale => 0
    t.integer  "assigned_cnt",  :precision => 38, :scale => 0
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "good_id",       :precision => 38, :scale => 0
  end

  create_table "ibt_search_criterias", :force => true do |t|
    t.integer   "respondent_id",              :precision => 38, :scale => 0
    t.timestamp "time_basis",    :limit => 6
    t.timestamp "created_at",    :limit => 6
    t.timestamp "updated_at",    :limit => 6
  end

  create_table "ibt_sorts", :force => true do |t|
    t.integer   "book_no",                      :precision => 38, :scale => 0
    t.integer   "ibtr_id",                      :precision => 38, :scale => 0
    t.integer   "consignment_id",               :precision => 38, :scale => 0
    t.string    "isbn"
    t.string    "flg_no_isbn"
    t.string    "flg_repeat_sort"
    t.string    "flg_success"
    t.timestamp "created_at",      :limit => 6
    t.timestamp "updated_at",      :limit => 6
  end

  create_table "ibtr_versions", :force => true do |t|
    t.integer   "ibtr_id",                    :precision => 38, :scale => 0
    t.integer   "version",                    :precision => 38, :scale => 0
    t.integer   "title_id",                   :precision => 38, :scale => 0
    t.integer   "member_id",                  :precision => 38, :scale => 0
    t.string    "card_id"
    t.integer   "branch_id",                  :precision => 38, :scale => 0
    t.integer   "rns_id",                     :precision => 38, :scale => 0
    t.string    "state"
    t.timestamp "created_at",    :limit => 6
    t.timestamp "updated_at",    :limit => 6
    t.string    "respondent_id"
    t.integer   "reason_id",                  :precision => 38, :scale => 0
    t.string    "comments"
    t.integer   "book_no",                    :precision => 38, :scale => 0
    t.string    "po_no"
    t.integer   "created_by",                 :precision => 38, :scale => 0
    t.integer   "modified_by",                :precision => 38, :scale => 0
  end

  create_table "ibtr_versions_dt", :id => false, :force => true do |t|
    t.integer   "id",                         :precision => 38, :scale => 0, :null => false
    t.integer   "ibtr_id",                    :precision => 38, :scale => 0
    t.integer   "version",                    :precision => 38, :scale => 0
    t.integer   "title_id",                   :precision => 38, :scale => 0
    t.integer   "member_id",                  :precision => 38, :scale => 0
    t.string    "card_id"
    t.integer   "branch_id",                  :precision => 38, :scale => 0
    t.integer   "rns_id",                     :precision => 38, :scale => 0
    t.string    "state"
    t.timestamp "created_at",    :limit => 6
    t.timestamp "updated_at",    :limit => 6
    t.string    "respondent_id"
    t.integer   "reason_id",                  :precision => 38, :scale => 0
    t.string    "comments"
  end

  create_table "ibtrs", :force => true do |t|
    t.integer   "title_id",                   :precision => 38, :scale => 0
    t.integer   "member_id",                  :precision => 38, :scale => 0
    t.string    "card_id"
    t.integer   "branch_id",                  :precision => 38, :scale => 0
    t.integer   "rns_id",                     :precision => 38, :scale => 0
    t.string    "state"
    t.timestamp "created_at",    :limit => 6
    t.timestamp "updated_at",    :limit => 6
    t.integer   "version",                    :precision => 38, :scale => 0
    t.string    "respondent_id"
    t.integer   "reason_id",                  :precision => 38, :scale => 0
    t.string    "comments"
    t.integer   "book_no",                    :precision => 38, :scale => 0
    t.string    "po_no"
    t.integer   "created_by",                 :precision => 38, :scale => 0
    t.integer   "modified_by",                :precision => 38, :scale => 0
  end

  add_index "ibtrs", ["card_id"], :name => "in_ibtrs_3"
  add_index "ibtrs", ["member_id"], :name => "in_ibtrs_4"
  add_index "ibtrs", ["rns_id"], :name => "in_ibtrs_1"
  add_index "ibtrs", ["state"], :name => "in_ibtrs_2"

  create_table "ibtrs_dt", :id => false, :force => true do |t|
    t.integer   "id",                         :precision => 38, :scale => 0, :null => false
    t.integer   "title_id",                   :precision => 38, :scale => 0
    t.integer   "member_id",                  :precision => 38, :scale => 0
    t.string    "card_id"
    t.integer   "branch_id",                  :precision => 38, :scale => 0
    t.integer   "rns_id",                     :precision => 38, :scale => 0
    t.string    "state"
    t.timestamp "created_at",    :limit => 6
    t.timestamp "updated_at",    :limit => 6
    t.integer   "version",                    :precision => 38, :scale => 0
    t.string    "respondent_id"
    t.integer   "reason_id",                  :precision => 38, :scale => 0
    t.string    "comments"
  end
end
