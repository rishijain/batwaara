class EventsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :get_event, only: [:edit, :update]

  def index
    @events = Event.all
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new event_params
    if @event.save
      flash[:success] = 'Event successfully created.'
      redirect_to events_path
    else
      render 'new'
    end
  end

  def update
    @event.attributes = event_params
    if @event.save
      flash[:success] = 'Event successfully updated.'
      redirect_to events_path
    else
      render 'edit'
    end
  end

  private

  def get_event
    @event = Event.find params[:id]
  end

  def event_params
    params.fetch(:event, {}).permit(:id, :name)
  end

end
