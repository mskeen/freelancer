class LogIp < Ohm::Model
  attribute :ip
  attribute :last_hit
  attribute :agent
  attribute :isp_lookup_done
  attribute :isp
  attribute :location
  counter :hits
  reference :log_monitor, :LogMonitor
  index :ip
  set :log_entries, :LogEntry

  def ip_lookup
    unless isp_lookup_done
      loc = HTTParty.get("http://ip-api.com/json/#{ip}")
      self.update(isp_lookup_done: 1, isp: loc["isp"], location: "#{loc['city']}, #{loc['countryCode']}")
    end
  end
end
