
@eightball = [ "It is certain",
              "It is decidedly so",
              "Without a doubt",
              "Yes, definitely",
              "You may rely on it",
              "As I see it, yes",
              "Most likely",
              "Outlook good",
              "Yes",
              "Signs point to yes",
              "Reply hazy try again",
              "Ask again later",
              "Better not tell you now",
              "Cannot predict now",
              "Concentrate and ask again",
              "Don't count on it",
              "My reply is no",
              "My sources say no",
              "Outlook not so good",
              "Very doubtful"
            ]

@members = Hash.new("unkown user - please check the spelling or the member is not currently in the database")
@members["gabemachida"]        = "GabeMachida - League[ GabeMachida ] - Gabe"
@members["professorpancake"]   = "ProfessorPancake - League[ SergeantScone ] - Ray"
@members["david"]              = "David - League[ BrianFranklin ] - David"
@members["kanzu"]              = "Kanzu - League[ Kanzu ] - Kanzu / Char"
@members["pcband04"]           = "pcband04 - League[ Fuego5 / Sevenpieces7 ] - Dan"
@members["icebluefire"]        = "IceBlueFire - League [ IceBlueFire ] - Adam"
@members["pn109a"]             = "pn109a - League [ Pn109a ] - James"
@members["raidboss"]           = "Raidboss - League [ Shadestealth ] - Ralphy"
@members["senpai"]             = "Senpai - League [ Banant ] - Tat"
@members["stjonnie"]           = "StJonnie - League [ StJonnie ] - Jonnie"
@members["burgermeizter"]      = "Burgermeizter - League [ Burgermeizter ] - Brandon"
@members["drakghoul"]          = "Drakghoul - League [ Drakghoul ] - Sam"
@members["gatorade"]           = "Gatorade - League [ HeroAnti ] - Wesley"
@members["goss"]               = "Goss - League [ Goss6 ] - Goss / John"
@members["jnigs"]              = "Jnigs - League [ Senpiee ] - Justin"
@members["knobbob"]            = "KnobBob - League [ LDxBroseph ] - Joe"
@members["mezmerized"]         = "Mezmerized - League [ MezmerizedSC ] - Zach"
@members["shamas888"]          = "Shamas888 - League [ ] - Seamus"
@members["spacenoodle"]        = "Spacenoodle - honorary member - Julian"
@members["gabes_henchman"]     = "Gabe's Henchman - that's me bitches"
@members["natid4"]             = "Natid4 - League [ Natid4 ] - Nate"

@help = [ "here are the list of available bot commands:",
          "whois - /whois username returns info on that username /whois all returns all names listed -- example: /whois gabemachida",
          "schedule - gives you a link to the lolesports.com schedule page",
          "champ - /champ champname returns info on champion abilities, optionally Q W E R can be appended to specific abilities -- example: /champ vayne q r",
          "insult - /insult name returns a random insult (your mileage may vary) -- example: /insult goss's_nose",
          "trivia - /trivia returns random trivia (again, your mileage may vary)",
          "motivate - /motivate name returns a customized motivational quote to help you -- example: /motivate brandon",
          "card - /card name returns all matching (and partially matching) hearthstone card images -- example: /card archmage antonidas",
          "name - /name name returns all partially matching names of cards",
          "8ball - /8ball question returns a magic eight ball answer -- example: /8ball should i go to work today?",
          "roles - /roles [name1 name2..name5][role1 role2..role5] randomizes names and roles -- example: /roles [john brandon ray char][adc jungle top mid]",
          "dice - /dice number returns a random number between 1 to the number -- example: /dice 6",
          "dice - /dice number1 number2 returns a number between and including the two numbers -- example: /dice 12 20",
          "dice - /dice [choice1 choice2... choiceX] returns a choice -- example /dice [adc jungle top]",
          "roll - same as dice",
          "reddit self - links to reddit self posts will return the first 1000 characters of the self post (to save you that click)",
          "help - /help... yeah..."

       ]