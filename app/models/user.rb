class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true, uniqueness: true,
                   length: { in: 2..20 }
  validates :introduction,  length:  { maximum: 50 }

  has_many :books, dependent: :destroy
    has_many :favorites, dependent: :destroy
    has_many :book_comments, dependent: :destroy
  attachment :profile_image

  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  #フォローする側から自分がフォローしている人取得
  has_many :followings, through: :relationships, source: :followed
  #ユーザーがフォローしている人全員取得
  has_many :reverse_of_relationships, class_name:"Relationship", foreign_key: "followed_id", dependent: :destroy
  #フォローされる側からフォローされている人取得
  has_many :followers, through: :reverse_of_relationships, source: :follower
  #ユーザーをフォローしている人全員取得

  def followed_by?(user)
    reverse_of_relationships.find_by(follower_id: user.id).present?
  end
end

