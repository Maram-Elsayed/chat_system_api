require 'redis'

class CreateChatJob < ApplicationJob
  queue_as 'default'

  def perform(application_id)
    lock_key = "lock:application:#{application_id}:chat_number"

    acquired = Redis.current.set(lock_key, 'locked', nx: true, ex: 5)

    if acquired
      begin
        application = Application.find(application_id)
        next_chat_number = Redis.current.get("chat_number:#{application_id}")
        application.chats.create!(number: next_chat_number, messages_count: 0)
      ensure
        Redis.current.del(lock_key)
      end
    else
      self.class.perform_later(application_id)
    end

  end
end
