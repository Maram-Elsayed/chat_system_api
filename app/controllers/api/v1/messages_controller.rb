class Api::V1::MessagesController < ActionController::API
  before_action :set_chat
  before_action :set_message, only: [:show, :update, :destroy]


  def index
    if params[:search].present?
      @messages = Message.all.search(params[:search], @chat.id).records
    else
      @messages = @chat.messages
    end
    render json: { messages: @messages.as_json(only: [:number, :body], include_chat_details: true) }
  end

  def create

    initialize_chat_counter(@chat.id)
    message_number =  Redis.current.incr("message_number:#{@chat.id}")
    CreateMessageJob.perform_later(@chat.id, params[:body])
    render json: { message_number: message_number }, status: :accepted
  end

  def show
    render json: { message: @message.as_json(only: [:number, :body], include_chat_details: true) }, status: :ok
  end

  def update
    if @message.update(message_params)
      render json: { message: @message.as_json(only: [:number, :body], include_chat_details: true) }
    else
      render json: { errors: @messages.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    if @message.destroy
      render json: { }, status: :no_content
    else
      render json: { errors: @message.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def message_params
    params.require(:message).permit(:body)    
  end

  def set_message
    @message = @chat.messages.find_by(number: params[:number])
    render json: { error: 'Message not found' }, status: :not_found if @message.nil?
  end

  def set_chat
    @application = Application.find_by(token: params[:application_token])
    render json: { error: 'Application not found' }, status: :not_found if @application.nil?

    @chat = @application.chats.find_by(number: params[:chat_number])
    render json: { error: 'Chat not found' }, status: :not_found if @chat.nil?
  end

  def initialize_chat_counter(chat_id)
    Redis.current.set("message_number:#{chat_id}", 0) unless Redis.current.exists?("message_number:#{chat_id}")
  end

end
