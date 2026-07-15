# Questions, choices, tags, and attached figures.

create_table "questions", force: :cascade, comment: "問題" do |t|
  t.references :exam, null: false, foreign_key: true, comment: "試験年度ID"
  t.references :subject, null: false, foreign_key: true, comment: "学科ID"
  t.integer  "number", null: false, comment: "問題番号"
  t.text     "body", null: false, comment: "問題文"
  t.text     "explanation", comment: "設問全体の解説"
  t.integer  "question_type", null: false, default: 0, comment: "出題形式（記述・選択・計算・比較）"
  t.boolean  "flashcard_eligible", null: false, default: true, comment: "一問一答対応可否"
  t.boolean  "has_figure", null: false, default: false, comment: "図表有無"
  t.timestamps
  t.index ["exam_id", "subject_id", "number"], name: "index_questions_on_exam_subject_number", unique: true
end

create_table "choices", force: :cascade, comment: "選択肢" do |t|
  t.references :question, null: false, foreign_key: true, comment: "問題ID"
  t.integer  "number", null: false, comment: "選択肢番号（1から5）"
  t.text     "body", null: false, comment: "選択肢文"
  t.boolean  "is_correct", null: false, default: false, comment: "5択としての正解フラグ"
  t.boolean  "is_true_statement", comment: "記述単体の真偽（一問一答用）"
  t.text     "explanation", comment: "肢別解説"
  t.timestamps
  t.index ["question_id", "number"], name: "index_choices_on_question_id_and_number", unique: true
end

create_table "tags", force: :cascade, comment: "分野タグ" do |t|
  t.string "name", null: false, comment: "タグ名（構造力学など）"
  t.timestamps
  t.index ["name"], name: "index_tags_on_name", unique: true
end

create_table "question_tags", force: :cascade, comment: "問題と分野タグの関連" do |t|
  t.references :question, null: false, foreign_key: true, comment: "問題ID"
  t.references :tag, null: false, foreign_key: true, comment: "タグID"
  t.timestamps
  t.index ["question_id", "tag_id"], name: "index_question_tags_on_question_id_and_tag_id", unique: true
end

create_table "figures", force: :cascade, comment: "図表" do |t|
  t.string  "attachable_type", null: false, comment: "紐付け先種別（Question、Choice）"
  t.bigint  "attachable_id", null: false, comment: "紐付け先ID"
  t.integer "position", null: false, default: 0, comment: "表示順"
  t.string  "caption", comment: "図表番号（図-1など）"
  t.timestamps
  t.index ["attachable_type", "attachable_id"], name: "index_figures_on_attachable"
end
