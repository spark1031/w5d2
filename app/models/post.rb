class Post < ApplicationRecord
  validates :title, presence: true
  validates :sub_id, presence: true

  has_many :post_subs, inverse_of: :post, dependent: :destroy
  has_many :subs, through: :post_subs, source: :sub

  belongs_to :author,
    foreign_key: :user_id,
    class_name: 'User',
    inverse_of: :posts
end
