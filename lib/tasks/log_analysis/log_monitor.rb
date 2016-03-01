class LogMonitor < Ohm::Model
  include LookupColumn

  attribute :site_id
  attribute :status_cd
  attribute :created_at
  index :site_id
  set :log_ips, :LogIp

  lookup_group :status, :status_cd do
    option :pending,          1, 'Pending'
    option :running,          2, 'Running'
    option :cancelled,        3, 'Cancelled'
    option :complete,         4, 'Complete'
  end

end
