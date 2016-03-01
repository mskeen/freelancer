class LogEntry < Ohm::Model
  attribute :logged_at
  attribute :method
  attribute :url
  attribute :status
  attribute :size
  attribute :referrer
  attribute :agent
  attribute :status_msg
  reference :log_ip, :LogIp
  index :ip
end
