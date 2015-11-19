# This simple bot responds to every "Ping!" message with a "Pong!"
require 'json'
require 'active_support/core_ext/module'
require 'discordrb'
require_relative 'mech'
require_relative 'whois'
require_relative 'helpers'


bot = Discordrb::Bot.new "mack@arigatos.net", ENV["HIDDEN_PASSWORD"], true

# ######## /whois
# bot.message(:starting_with => '/whois') do |event|
#   puts event.message.text
#   name = event.message.text.split(" ")[1]
#   if name.is_a? String
#     name = name.downcase
#     event.respond @members[name]
#   else
#     if event.message.text == '/whoisall'
#       @members.each do |key, member|
#         puts member
#         event.respond member unless key == "gabes_henchman"
#       end
#     else
#       event.respond "type /whois followed by the member's name to get a list of their IGNs"
#       event.respond "there's also a chance that member hasn't been added to the database"
#     end 
#   end
# end

######## /schedule

bot.message(:with_text => "/schedule") do |event|
  # event.respond "http://na.lolesports.com/schedule"
  event.respond "http://worlds.lolesports.com/en_US/worlds"
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
  lazy = rand(5)
  if lazy == 0
    event.respond Mech.new.get_new_trivia
  else
    event.respond Mech.new.get_trivia
  end
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


########## /name
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

################ /8ball
bot.message(:starting_with => "/8ball") do |event|
  event.respond @eightball[ rand(20) ]
end

############# /roles
bot.message(:starting_with => "/role") do |event|
  event.respond Mech.new.get_roles(event.message.text)
end

############# /dice
bot.message(:starting_with => ["/dice", "/roll"] ) do |event|
  if event.message.text.strip.length == 5
    event.respond (rand(6) + 1).to_s
  else
    text = event.message.text[5..-1].strip
    puts text

    if text.include?("[") && text.include?("]")
      regex = /\[(.*?)\]/
      options = text.scan(regex)[0][0].split
      event.respond options[ rand(options.length) ]
    else
      if !/\A\d+\z/.match(text)
        #if two values
        if text.split.length >= 2
          val1 = text.split[0].to_i
          val2 = text.split[1].to_i

          if val1 > val2
            temp = val1; val1 = val2; val2 = temp
          end

          diff = val2 - val1
          event.respond ( val1 + rand(diff) + rand(2) ).to_s

        else
          event.respond "format not recognized for /roll /dice."
          event.respond " /roll or /dice are interchangeable"
          event.respond " /dice with no arguments will roll a 6 sided die"
          event.respond " /dice with a positive integer value will roll a value from 1 to that value"
          event.respond " /dice with two postiive integer values will roll a value between those values"
          event.respond " /dice [value1 value2 value3 ...] will roll a random named value" 
        end 
      else
        #Is all good ..continue
        event.respond (rand(text.to_i) + 1).to_s
      end  
    end
  end
end


########### reddit self

bot.message(:containing => "https://www.reddit.com/r/"  ) do |event|
  text = event.message.text
  text = text[0..-6] if text[-5..-1].downcase == ".json"
  text = text[0...-1] if text[-1] == "/"

  regex = /https:\/\/www.reddit.com\/r\/(.*?)\/comments\/(.*)/

  subreddit = text.scan(regex)

  unless subreddit[0] == nil && subreddit[1] == nil
    text = Mech.new.get_selfpost(subreddit[0][0], subreddit[0][1])
    event.respond text unless text == ""
  end
end


###### help
############# /roles
bot.message(:starting_with => "/help") do |event|
  event.respond "help? let me send you a direct message."
  @help.each do |h|
    event.message.user.pm(h)
  end
end


bot.run