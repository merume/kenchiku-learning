class Exam < ApplicationRecord
  belongs_to :license_type
  has_many :questions, dependent: :destroy

  validates :year, presence: true, uniqueness: { scope: :license_type_id }
end
