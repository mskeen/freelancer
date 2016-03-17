class LogMonitor < Ohm::Model
  attribute :log_type
  attribute :log_filter
  attribute :site_id
  attribute :status
  attribute :created_at
  counter :hits
  index :site_id
  set :log_ips, :LogIp
end
