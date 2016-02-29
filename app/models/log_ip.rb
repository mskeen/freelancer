class LogIp < ActiveRecord::Base
  belongs_to :log_monitor
  has_many :log_entries
end
