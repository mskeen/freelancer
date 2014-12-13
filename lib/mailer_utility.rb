class MailerUtility

  def self.try_delivery(options = {}, &block)
    begin
      yield
      return true
    rescue  EOFError,
            IOError,
            TimeoutError,
            Errno::ECONNRESET,
            Errno::ECONNABORTED,
            Errno::EPIPE,
            Errno::ETIMEDOUT,
            Net::SMTPAuthenticationError,
            Net::SMTPServerBusy,
            Net::SMTPSyntaxError,
            Net::SMTPUnknownError,
            OpenSSL::SSL::SSLError => e
      return false
    end
  end

end
