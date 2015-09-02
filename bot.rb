# This simple bot responds to every "Ping!" message with a "Pong!"
require 'json'
require 'discordrb'
require_relative 'mech'
require_relative 'whois'
require_relative 'helpers'

bot = Discordrb::Bot.new "mack@arigatos.net", ENV["HIDDEN_PASSWORD"]

######## /whois
bot.message(:starting_with => '/whois') do |event|
  puts event.message.text
  name = event.message.text.split(" ")[1]
  if name.is_a? String
    name = name.downcase
    event.respond members[name]
  else
    if event.message.text == '/whoisall'
      members.each do |key, member|
        puts member
        event.respond member unless key == "gabes_henchman"
      end
    else
      event.respond "type /whois followed by the member's name to get a list of their IGNs"
      event.respond "there's also a chance that member hasn't been added to the database"
    end 
  end
end

######## /schedule

bot.message(:with_text => "/schedule") do |event|
  event.respond "http://na.lolesports.com/schedule"
end

########/insult

bot.message(:starting_with => "/insult") do |event|
  puts event.message.text
  name = event.message.text.split(" ")[1]

  if name.is_a? String
    name = name.downcase
    event.respond "hey " + name + "! " + Mech.new.get_new_insult.downcase.gsub(".","!")
  else
    not_a_string(event)
  end
end

################ /trivia
bot.message(:with_text => "/trivia") do |event|
  event.respond Mech.new.get_new_trivia
end

##############/motivate

bot.message(:starting_with => "/motivate") do |event|
  puts event.message.text
  name = event.message.text.split(" ")[1]

  if name.is_a? String
    name = name.downcase
    event.respond "listen, " + name + ". " + Mech.new.get_new_motivation.downcase
  else
    not_a_string(event)
  end
end

########/card

bot.message(:starting_with => "/card") do |event|
  if event.message.channel.name == "hearthstone_chat"
    name = event.message.text.gsub("/card", "")
    if name.is_a? String
      cards = Mech.new.get_card(name)
      if cards.empty?
        event.respond "no match found"
      else
        cards.each { |card| event.respond(card) }
      end
    else
      not_a_string(event)
    end
  else
    event.respond "sorry... my master has restricted my usage to only the hearthstone_chat channel"
  end
end

bot.message(:starting_with => "/name") do |event|
  if event.message.channel.name == "hearthstone_chat"
    name = event.message.text.gsub("/name", "")
    if name.is_a? String
      cards = Mech.new.get_card_name(name)
      if cards.empty?
        event.respond "no match found"
      else
        cards.each { |card| event.respond(card) }
      end
    else
      not_a_string(event)
    end
  else
    event.respond "sorry... my master has restricted my usage to only the hearthstone_chat channel"
  end
end

bot.run