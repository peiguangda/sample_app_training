class Micropost < ApplicationRecord
  belongs_to :user
  scope :descending_order, ->{order created_at: :desc}
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true,
    length: {maximum: Settings.content.maximum}
  validate :picture_size

  private

  def picture_size
    return unless picture.size > Settings.picture.maxsize.megabytes
    errors.add :picture, I18n.t("over_size_msg")
  end
end
