class ChatMessagesCountWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'chats_messages_count' 
  

  def perform(application_id)
    application = Application.find(application_id)
    return unless application.present? || !application&.chats.blank?

    application.chats.each do |chat|
      next if chat&.messages&.blank?
      puts "messages_count = #{ chat&.messages&.size}"
      chat.update(messages_count: chat&.messages&.size)
    end
  end

end