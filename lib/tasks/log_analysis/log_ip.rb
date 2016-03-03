class LogIp < Ohm::Model
  attribute :ip
  attribute :last_hit
  attribute :agent
  counter :hits
  reference :log_monitor, :LogMonitor
  index :ip
  set :log_entries, :LogEntry
end
