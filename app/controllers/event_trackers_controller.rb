class EventTrackersController < ApplicationController
  respond_to :html

  before_action :set_event_tracker, only: [:show, :edit, :update, :destroy]

  def index
    @event_trackers = current_user.event_trackers.all
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
    @event_tracker = current_user.event_trackers.new(event_tracker_params)
    @event_tracker.organization = current_user.organization
    @event_tracker.save
    respond_with(@event_tracker, location: event_trackers_path)
  end

  def update
    @event_tracker.update(event_tracker_params)
    respond_with(@event_tracker)
  end

  def destroy
    @event_tracker.update_attributes(is_deleted: true)
    respond_with(@event_tracker)
  end

  private

  def set_event_tracker
    @event_tracker = current_user.event_trackers.find(params[:id])
  end

  def event_tracker_params
    params.require(:event_tracker).permit(
      :name, :email, :notes, :interval_cd,
      :sort_order, :is_paused, :is_deleted)
  end
end
