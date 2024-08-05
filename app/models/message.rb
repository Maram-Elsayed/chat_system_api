require 'elasticsearch/model'
class Message < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  belongs_to :chat

  validates :number, presence: true
  validates :body, presence: true
  validates :chat_id, presence: true
  validates :number, uniqueness: { scope: :chat_id, message: 'Message number must be unique within the same chat' }


  settings index: { number_of_shards: 1 } do
    mappings dynamic: 'false' do
      indexes :body, analyzer: 'english'
      indexes :chat_id, type: 'integer'
    end
  end

  def as_json(options = {})
  base = super(options)
  if options[:include_chat_details]
    base[:chat_number] = chat&.number 
    base[:application_token] = chat&.application&.token
  end
  
    base
  end

  def as_indexed_json(options = {})
    as_json(only: [:body, :chat_id])
  end

  def self.create_index_and_import
    __elasticsearch__.create_index!(force: true)
    import
  end

  def self.search(query,chat_id)
    __elasticsearch__.search(
      {
        query: {
          bool: {
            must: {
              wildcard: {
                body: {
                  value: "*#{query}*",
                  case_insensitive: true
                }
              }
            },
            filter: {
              term: {
                chat_id: chat_id
              }
            }
          }
        }
      }
    )
  rescue Elasticsearch::Transport::Transport::Errors::NotFound => e
    Rails.logger.error "Elasticsearch index not found: #{e.message}"
    Message.none
  end

end
