# This simple bot responds to every "Ping!" message with a "Pong!"
require 'json'
require 'active_support/core_ext/module'
require 'discordrb'
require_relative 'mech'
require_relative 'whois'
require_relative 'helpers'

bot = Discordrb::Bot.new "mack@arigatos.net", ENV["HIDDEN_PASSWORD"], true

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

#########/ champ
bot.message(:starting_with => "/champ") do |event|
  parse_string = event.message.text[7..-1].downcase
  parse = parse_string.split(/[\s,]+/)
  champ_name = ""
  show_link = false
  skills = []
  getting_name = true
  parse.each do |p|
    champ_name = champ_name + " " + p if p.length > 1 && getting_name
    
    if p.length == 1
      getting_name = false
      skills << :innate if p == "p"
      skills << :q if p == "q"
      skills << :w if p == "w"
      skills << :e if p == "e"
      skills << :r if p == "r"
    end

    if parse_string.include?("passive")
      skills << :innate
    end

    skills.uniq!
  end

  if skills.empty?
    skills = [ :innate, :q, :w, :e, :r ]
    show_link = true
  end

  champ_name = champ_name.strip
  abilities = Mech.new.get_champ(champ_name, skills)

  event.respond champ_name.capitalize
  if abilities.any?
    skills.each do |skill|
      skill_string = skill.to_s.upcase if skill.length == 1
      skill_string = "Passive" if skill == :innate
      event.respond skill_string + " - " + abilities[skill][:title]
      event.respond abilities[skill][:info1]
      event.respond abilities[skill][:info2] if abilities[skill][:info2].length > 0 
      event.respond abilities[skill][:range]
      event.respond abilities[skill][:cost]
      event.respond abilities[skill][:cooldown]
      event.respond " "
    end
    event.respond abilities[:link]
  else
    event.respond "Champion by that name not found. Check your spelling, man."
    event.respond "btw... evelynn not evelyn" if champ_name.downcase == "evelyn"
  end

end


########/insult

bot.message(:starting_with => "/insult") do |event|
  puts event.message.text
  name = event.message.text.split(" ")[1]

  if event.message.user.name.downcase == "raidboss"
    event.respond "hey ralphy! " + Mech.new.get_new_insult.downcase.gsub(".","!")
    event.respond "and btw... don't chase."
  else
    if name.is_a? String
      name = name.downcase
      event.respond "hey " + name + "! " + Mech.new.get_new_insult.downcase.gsub(".","!")
    else
      not_a_string(event)
    end
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