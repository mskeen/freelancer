class AppConfig
  def self.respond_to?(method, priv = false)
    Rails.application.secrets.respond_to(method, priv)
  end

  def self.method_missing(sym, *args)
    if Rails.application.secrets.respond_to?(sym)
      return Rails.application.secrets.send(sym, args)
    end
    super
  end
end
