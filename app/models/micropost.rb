class Micropost < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  scope :newest, ->{order created_at: :desc}
  scope :by_user_id, ->(id){where user_id: id}
  validates :user_id, presence: true
  validates :content, presence: true,
                      length: {maximum: Settings.digit.length_140}
  validates :image, content_type: {
                      in: %w(image/jpeg image/gif image/png),
                      message: I18n.t("errors.messages.invalid_image_format")
                    },
                    size: {
                      less_than: Settings.digit.size_5.megabytes,
                      message: I18n.t("errors.messages.invalid_image_size",
                                      size: Settings.digit.size_5)
                    }

  def display_image
    image.variant resize_to_limit: [Settings.digit.size_500,
                                    Settings.digit.size_500]
  end
end
