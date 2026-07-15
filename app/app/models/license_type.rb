class LicenseType < ApplicationRecord
  has_many :subjects, dependent: :restrict_with_error
  has_many :exams, dependent: :restrict_with_error

  validates :code, presence: true, uniqueness: true
  validates :name, presence: true
end
