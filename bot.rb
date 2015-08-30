# This simple bot responds to every "Ping!" message with a "Pong!"
require 'json'
require 'discordrb'
require_relative 'mech'
require_relative 'helpers'

members = Hash.new("unkown user - please check the spelling or the member is not currently in the database")
members["gabemachida"]        = "GabeMachida - League[ GabeMachida** ] - Gabe"
members["professorpancake"]   = "ProfessorPancake - League[ SergeantScone ] - Ray"
members["david"]              = "David - League[ BrianFranklin ] - David"
members["kanzu"]              = "Kanzu - League[ Kanzu ] - Kanzu / Char"
members["pcband04"]           = "pcband04 - League[ Fuego5 / Sevenpieces7 ] - Dan"
members["icebluefire"]        = "IceBlueFire - League [ IceBlueFire ] - Adam"
members["pn109a"]             = "pn109a - League [ Pn109a ] - James"
members["raidboss"]           = "Raidboss - League [ Shadestealth ] - Ralphy"
members["senpai"]             = "Senpai - League [ Banant ] - Tat"
members["stjonnie"]           = "StJonnie - League [ StJonnie ] - Jonnie"
members["burgermeizter"]      = "Burgermeizter - League [ Burgermeizter ] - Brandon"
members["drakghoul"]          = "Drakghoul - League [ Drakghoul ] - Sam"
members["gatorade"]           = "Gatorade - League [ HeroAnti ] - Wesley"
members["goss"]               = "Goss - League [ Goss6 ] - Goss / John"
members["jnigs"]              = "Jnigs - League [ Senpiee ] - Justin"
members["knobbob"]            = "KnobBob - League [ LDxBroseph ] - Joe"
members["mezmerized"]         = "Mezmerized - League [ MezmerizedSC ] - Zach"
members["shamas888"]          = "Shamas888 - League [ ] - Seamus"
members["spacenoodle"]        = "Spacenoodle - honorary member - Julian"
members["gabes_henchman"]     = "Gabe's Henchman - that's me bitches"

bot = Discordrb::Bot.new "mack@arigatos.net", ENV["HIDDEN_PASSWORD"]

######## /whois
bot.message(:starting_with => '/whois') do |event|
  puts event.message.textGh
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

########/card

bot.message(:starting_with => "/card") do |event|
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
end

bot.run