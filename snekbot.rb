require 'dotenv/load'
require 'date'
require 'telegram/bot'

TOKEN = ENV['TELEGRAM_TOKEN']

class Snekbot

  def initialize
    puts "Snekbot running"
    Telegram::Bot::Client.run(TOKEN) do |bot|
      bot.listen do |message|
        case message.text
        when /^\/halo\s*.*/
          bot.api.send_message(chat_id: message.chat.id, reply_to_message_id: message.id, text: "Halo, #{message.from.first_name}")
        when '/snek'
          bot.api.send_message(chat_id: message.chat.id, text: today_snek_message)
        end
      end
    end
  end

  def today_snek_message
    sneker = snek_list(Date.today)
    if sneker.empty?
      "Snek lagi libur woi!"
    else
      "Hai, jangan lupa beli snek hari ini yaa: \n#{sneker.join(" ")}"
    end
  end

  def snek_list(date)
    day_num = date.strftime("%u").to_i
    case day_num
    when 1
      %w(@annislatif @ediliu @fitrirahmadhani @danshortyshort)
    when 2
      %w(@ichkautzar @archelia @alvinya1 @Insomnius)
    when 3
      %w(@setiadialvin @fadhilurrizki @aimanazka @tunjungaulia @Nadiarahmatin)
    when 4
      %w(@rahmijs @agusdhito @ariyohendrawan @blad_runner)
    when 5
      %w(@dracius @nicmarianes @iqbalperkasa @hesahesa)
    else
      []
    end
  end
end

Snekbot.new
