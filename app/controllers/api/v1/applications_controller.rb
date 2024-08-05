class Api::V1::ApplicationsController < ActionController::API
  before_action :set_application, only: [:show, :update, :destroy]

  def index
    @applications = Application.all
    render json: { applications: @applications.as_json(only: [:name, :token, :chats_count]) }
  end

  def create
    @application = Application.new(application_params)
    @application.chats_count = 0
    
    if @application.save
      render json: { application: @application.as_json(only: [:name, :token, :chats_count]) }, status: :created
    else
      render json: { errors: @application.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    render json: { application: @application.as_json(only: [:name, :token, :chats_count]) }, status: :ok
  end

  def update
    if @application.update(name: params[:name])
      render json: { application: @application.as_json(only: [:name, :token, :chats_count]) }, status: :ok
    else
      render json: { errors: @application.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    if @application.destroy
      render json: { }, status: :no_content
    else
      render json: { errors: @application.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_application
    @application = Application.find_by(token: params[:token])
    render json: { error: 'Application not found' }, status: :not_found if @application.nil?
  end

  def application_params
    params.require(:application).permit(:name)
  end

end
