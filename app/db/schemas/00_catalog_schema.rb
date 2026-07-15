# License types, examinations, and their subjects.

create_table "license_types", force: :cascade, comment: "資格種別" do |t|
  t.string   "code", null: false, comment: "資格コード（class1、class2、wooden など）"
  t.string   "name", null: false, comment: "資格名（一級建築士など）"
  t.timestamps
  t.index ["code"], name: "index_license_types_on_code", unique: true
end

create_table "exams", force: :cascade, comment: "試験年度" do |t|
  t.references :license_type, null: false, foreign_key: true, comment: "資格種別ID"
  t.integer  "year", null: false, comment: "西暦年"
  t.string   "era_label", comment: "和暦表示（令和7年など）"
  t.timestamps
  t.index ["license_type_id", "year"], name: "index_exams_on_license_type_id_and_year", unique: true
end

create_table "subjects", force: :cascade, comment: "学科" do |t|
  t.references :license_type, null: false, foreign_key: true, comment: "資格種別ID"
  t.string   "code", null: false, comment: "学科コード（IからV）"
  t.string   "name", null: false, comment: "学科名（計画、法規など）"
  t.timestamps
  t.index ["license_type_id", "code"], name: "index_subjects_on_license_type_id_and_code", unique: true
end
