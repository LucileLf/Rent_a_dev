class DevelopersController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]
  before_action :set_developer, only: [:show, :edit, :update, :destroy]

  def index
    @developers = Developer.all
    if params[:query].present?
      #@developers = policy_scope(Developer).where("city ILIKE :query OR description ILIKE :query", query: "%#{params[:query]}%")
      @developers = policy_scope(Developer).search_by_city_and_description(params[:query])

    else
      @developers = policy_scope(Developer)
    end
  end

  def show
    authorize @developer
    @booking = Booking.new
    @review = Review.new
    @markers = [{
      lng: @developer.longitude,
      lat: @developer.latitude
    }]
  end

  def new
    @developer = Developer.new
    authorize @developer
  end

  def create
    @developer = Developer.new(developer_params)
    @developer.user = current_user
    if @developer.save
    redirect_to developer_path(@developer)
    else
      render :new
    end
    authorize @developer
  end

  def edit
    authorize @developer
  end

  def update
    authorize @developer
    if @developer.update!(developer_params)
      redirect_to developer_path(@developer)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @developer.destroy
    redirect_to user_profile_path(current_user), status: :see_other
    authorize @developer
  end

  private

  def set_developer
    @developer = Developer.find(params[:id])
  end

  def developer_params
    params.require(:developer).permit(:first_name, :last_name, :description, :city, :image_url, :price_per_day, :photo)
  end
end
