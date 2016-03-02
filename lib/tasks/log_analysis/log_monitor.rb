class LogMonitor < Ohm::Model
  attribute :log_type
  attribute :site_id
  attribute :status
  attribute :created_at
  index :site_id
  set :log_ips, :LogIp
end
