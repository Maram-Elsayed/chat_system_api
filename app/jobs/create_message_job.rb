require 'redis'

class CreateMessageJob < ApplicationJob
  queue_as 'default'

  def perform(chat_id, body)
    lock_key = "lock:chat:#{chat_id}:message_number"

    acquired = Redis.current.set(lock_key, 'locked', nx: true, ex: 5)

    if acquired
      begin
        chat = Chat.find(chat_id)
        next_message_number = Redis.current.get("message_number:#{chat_id}")
        chat.messages.create!(number: next_message_number, body: body)
      ensure
        Redis.current.del(lock_key)
      end
    else
      self.class.perform_later(chat_id)
    end

  end
end
