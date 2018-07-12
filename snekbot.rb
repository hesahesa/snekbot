require 'dotenv/load'
require 'date'
require 'telegram/bot'
require './async_send_message'

class Snekbot
  TOKEN = ENV['TELEGRAM_TOKEN']
  MESSAGE_PER_10_SEC = 3
  NUM_SECONDS = 10

  def initialize
    puts "Snekbot running"
    @curr_obj = self
    Telegram::Bot::Client.run(TOKEN) do |bot|
      bot.listen do |message|
        case message.text
        when /^\/halo\s*.*/
          puts "[#{Time.now}] /halo in #{message.chat.id}-> #{message.text}"
          if !@curr_obj.throttled?("halo", message.chat.id)
            AsyncSendMessage.perform_async(bot, chat_id: message.chat.id,
                                           reply_to_message_id: message.message_id,
                                           text: "Halo, #{message.from.first_name}")
          else
            puts "throttled"
          end
        when /^\/lele\s*.*/
          puts "[#{Time.now}] /lele in #{message.chat.id}-> #{message.text}"
          if !@curr_obj.throttled?("lele", message.chat.id)
            AsyncSendMessage.perform_async(bot, chat_id: message.chat.id,
                                           reply_to_message_id: message.message_id, text: "zumba dl")
          else
            puts "throttled"
          end
        when /^\/snek\s*.*/
          puts "[#{Time.now}] /snek in #{message.chat.id}-> #{message.text}"
          if !@curr_obj.throttled?("snek", message.chat.id)
            AsyncSendMessage.perform_async(bot, chat_id: message.chat.id, text: today_snek_message)
          else
            puts "throttled"
          end
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

  def throttled?(throttle_key, chat_id)
    @throttle_hash ||= {}
    ctr_key = "ctr_#{throttle_key}_#{chat_id}"
    sent_at_key = "sent_at_#{throttle_key}_#{chat_id}"

    @throttle_hash[ctr_key] ||= 0
    @throttle_hash[sent_at_key] ||= Time.now

    elapsed_seconds = ((Time.now - @throttle_hash[sent_at_key]) * 24 * 60 * 60 / 100000).to_i

    if elapsed_seconds <= NUM_SECONDS
      # if <= NUM_SECONDS seconds, check if throttled or not
      @throttle_hash[ctr_key] += 1
      (@throttle_hash[ctr_key] > MESSAGE_PER_10_SEC)? true : false
    else
      # reset throttle, because > NUM_SECONDS seconds
      @throttle_hash[ctr_key] = 0
      @throttle_hash[sent_at_key] = Time.now
      false
    end
  end
end

Snekbot.new
