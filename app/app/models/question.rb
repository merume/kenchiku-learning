class Question < ApplicationRecord
  # 出題形式
  #   single_statement: 4肢の記述から選ぶ通常タイプ(一問一答に展開可能)
  #   calculation:       数値計算問題(記述の真偽という概念がない)
  #   comparison:        大小関係・組合せを問う問題(肢単体では真偽判定できない)
  enum :question_type, { single_statement: 0, calculation: 1, comparison: 2 }, default: :single_statement

  belongs_to :exam
  belongs_to :subject

  has_many :choices, -> { order(:number) }, dependent: :destroy
  has_many :question_tags, dependent: :destroy
  has_many :tags, through: :question_tags
  has_many :figures, -> { order(:position) }, as: :attachable, dependent: :destroy

  accepts_nested_attributes_for :choices

  validates :number, presence: true, uniqueness: { scope: [:exam_id, :subject_id] }
  validates :body, presence: true

  before_validation :set_flashcard_eligible

  def correct_choice
    choices.find_by(is_correct: true)
  end

  private

  # question_type から一問一答モードに出せるかを機械的に決める。
  # 例外的に手動で上書きしたい場合はこのコールバックを外して直接編集できるようにする。
  def set_flashcard_eligible
    self.flashcard_eligible = single_statement?
  end
end
