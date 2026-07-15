class Subject < ApplicationRecord
  belongs_to :license_type
  has_many :questions, dependent: :restrict_with_error

  validates :code, presence: true, uniqueness: { scope: :license_type_id }
  validates :name, presence: true
end
