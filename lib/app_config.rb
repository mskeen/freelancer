class AppConfig
  def self.method_missing(sym, *args)
    return Rails.application.secrets.send(sym, args)
  end
end
