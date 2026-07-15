class Choice < ApplicationRecord
  belongs_to :question
  has_many :figures, -> { order(:position) }, as: :attachable, dependent: :destroy

  validates :number, presence: true, inclusion: { in: 1..5 }, uniqueness: { scope: :question_id }
  validates :body, presence: true
  validate :is_true_statement_present_when_flashcard_eligible

  private

  # 一問一答対応の問題では、肢ごとの真偽(is_true_statement)が必須
  def is_true_statement_present_when_flashcard_eligible
    return unless question&.flashcard_eligible?

    if is_true_statement.nil?
      errors.add(:is_true_statement, "は一問一答対応の問題では入力必須です")
    end
  end
end
