class LogMonitor < ActiveRecord::Base
  include LookupColumn

  attr_accessor :status_cd, :created_at

  lookup_group :status, :status_cd do
    option :pending,          1, 'Pending'
    option :running,          2, 'Running'
    option :cancelled,        3, 'Cancelled'
    option :complete,         4, 'Complete'
  end

  after_create :process_in_background

  private

  def process_in_background
    LogMonitorWorker.perform_async(self.id)
  end

end
