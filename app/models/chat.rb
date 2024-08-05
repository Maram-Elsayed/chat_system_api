class Chat < ApplicationRecord
  belongs_to :application
  has_many :messages, dependent: :destroy

  validates :number, presence: true
  validates :application_id, presence: true
  validates :number, uniqueness: { scope: :application_id, message: 'Chat number must be unique within the same application' }

  def as_json(options = {})
    base = super(options)
    base[:application_token] = application&.token if options[:include_application_token]
    base
  end

end
