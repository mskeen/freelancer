class LogMonitor < ActiveRecord::Base
  include LookupColumn

  belongs_to :user
  belongs_to :site

  lookup_group :status, :status_cd do
    option :pending,          1, 'Pending'
    option :running,          2, 'Running'
    option :cancelled,        3, 'Cancelled'
    option :complete,         4, 'Complete'
  end

end
