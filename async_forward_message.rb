require 'sucker_punch'

class AsyncForwardMessage
  include SuckerPunch::Job

  def perform(bot, options = {})
    bot.api.forward_message(options)
  end
end