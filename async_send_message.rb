require 'sucker_punch'

class AsyncSendMessage
  include SuckerPunch::Job

  def perform(bot, options = {})
    bot.api.send_message(options)
  end

end