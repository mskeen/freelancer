class EventTrackersController < ApplicationController
  respond_to :html

  before_action :set_event_tracker, only: [:show, :edit, :update, :destroy]

  def index
    @event_trackers = EventTracker.all
    respond_with(@event_trackers)
  end

  def show
    respond_with(@event_tracker)
  end

  def new
    @event_tracker = EventTracker.new(email: current_user.email)
    respond_with(@event_tracker)
  end

  def edit
  end

  def create
    @event_tracker = EventTracker.new(event_tracker_params)
    @event_tracker.save
    respond_with(@event_tracker)
  end

  def update
    @event_tracker.update(event_tracker_params)
    respond_with(@event_tracker)
  end

  def destroy
    @event_tracker.destroy
    respond_with(@event_tracker)
  end

  private
    def set_event_tracker
      @event_tracker = EventTracker.find(params[:id])
    end

    def event_tracker_params
      params.require(:event_tracker).permit(:user_id, :organization_id, :name, :email, :notes, :interval_cd, :token, :sort_order, :is_paused, :is_deleted)
    end
end
