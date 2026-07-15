class Figure < ApplicationRecord
  belongs_to :attachable, polymorphic: true
  has_one_attached :image

  validates :position, presence: true
  validate :image_must_be_attached

  private

  def image_must_be_attached
    errors.add(:image, "を添付してください") unless image.attached?
  end
end
