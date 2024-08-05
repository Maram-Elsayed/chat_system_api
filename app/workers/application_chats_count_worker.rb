class ApplicationChatsCountWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'chats_messages_count'

  def perform
    puts"Running update_chats_messages_count"

    Application.all.each do |application|
      next if application.chats.blank?

      puts"chats_count = #{application.chats.size}"
      application.update(chats_count: application.chats.size)
      Sidekiq::Client.enqueue_to("chats_messages_count", ChatMessagesCountWorker, application.id)
    end

   
  end
end
