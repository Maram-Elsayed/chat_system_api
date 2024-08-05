class Application < ApplicationRecord
  has_many :chats, dependent: :destroy

  before_create :generate_unique_token

  validates_uniqueness_of :token
  validates :name, presence: true

  private

  def generate_unique_token
    begin
      self.token = SecureRandom.hex(20)
    end while self.class.exists?(token: token)
  end

end
