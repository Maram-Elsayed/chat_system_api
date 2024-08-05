class Api::V1::ChatsController < ActionController::API
  before_action :set_application
  before_action :set_chat, only: [:show, :destroy]

  def index
    @chats = @application.chats
    render json: { chats: @chats.as_json(only: [:number, :messages_count], include_application_token: true) }
  end

  def create
    initialize_chat_counter(@application.id)
    chat_number =  Redis.current.incr("chat_number:#{@application.id}")
    CreateChatJob.perform_later(@application.id)
    render json: { chat_number: chat_number }, status: :accepted
  end

  def show
    render json: { chat: @chat.as_json(only: [:number, :messages_count], include_application_token: true) }, status: :ok
  end

  def destroy
    if @chat.destroy
      render json: { }, status: :no_content
    else
      render json: { errors: @chat.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_chat
    @chat = @application.chats.find_by(number: params[:number])
    render json: { error: 'Chat not found' }, status: :not_found if @chat.nil?
  end

  def set_application
    @application = Application.find_by(token: params[:application_token])
    render json: { error: 'Application not found' }, status: :not_found if @application.nil?
  end

  def initialize_chat_counter(application_id)
    Redis.current.set("chat_number:#{application_id}", 0) unless Redis.current.exists?("chat_number:#{application_id}")
  end

end
