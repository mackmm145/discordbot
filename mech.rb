require "mechanize"

class Mech
  def initialize
    @agent = Mechanize.new
  end

  def get_roles(text)
    regex = /\[(.*?)\]/
    s = Array.new
    s << text.scan(regex)[0][0]
    s << text.scan(regex)[1][0]

    if s[0].nil? or s[1].nil? #make sure the formatting was correct
      return "please use the format /roles [top jun mid adc sup][brandon jonnie char ray ralpy] the first [] and second [] require the same number of fields."
    else
      #makes sure that theres some values
      f = Array.new
      f[0] = s[0].split
      f[1] = s[1].split

      f.each do |field|
        field.collect! { |g| g.chomp }
      end

      if f[0].count == f[1].count
        f[1] = f[1].shuffle
        return f[0].each_with_index.map {|g, i| g + ": " + f[1][i]}
      else
        return "the first [] and second [] require the same number of fields."
      end

      puts f.inspect
    end

  end

  def get_new_insult
    @agent.get("http://www.insultgenerator.org/")
    comment = @agent.page.parser.css("div.wrap").first
    comment.text.strip
  end

  def get_new_trivia
    @agent.get("http://www.djtech.net/humor/useless_facts.htm")
    trivia_list = []
    @agent.page.parser.css("li > p").each do |trivia|
      trivia_list << trivia.text.strip.gsub("\r", "").gsub("\n", "")
    end
    trivia_list.sample
  end

  def get_new_motivation
    @agent.get("http://veryrandomstreams.blogspot.com/2010/06/100-great-quotes-about-motivation-and.html")
    comments = @agent.page.parser.css("div.post-body > div")[2].text.split("\n\n")
    comments.map! {|comment| comment.gsub("\n","")[3..-1].strip}
    return comments.sample
  end

  def get_card(name)
    @agent.get("http://www.hearthpwn.com/cards?display=3&filter-name=" + name.gsub(" ", "+"))
    cards = @agent.page.parser.css("div.card-image-item img")
    card_src = []
    unless cards.nil?
      cards.each { |card| card_src << card.attributes["src"] }
    end
    
    return card_src
  end
 
  def get_card_name(name)
    @agent.get("http://www.hearthpwn.com/cards?display=1&filter-name=" + name.gsub(" ", "+"))
    cards = @agent.page.parser.css("td.col-name a")
    card_src = []
    unless cards.nil?
      cards.each { |card| card_src << card.text }
    end
    
    return card_src    
  end

  def get_champ(name, skills)
    champ_name = name.split(/(\W)/).map(&:capitalize).join
    link =  "http://leagueoflegends.wikia.com/wiki/" + champ_name.gsub(" ", "_")
    puts link
    @agent.get( "http://leagueoflegends.wikia.com/wiki/" + champ_name.gsub(" ", "_") )
    return {} if @agent.page.parser.css("div.skill_innate table")[0].nil?

    abilities = Hash.new

    skills.each do | skill |
      div_skill = "div.skill_" + skill.to_s
      title = @agent.page.parser.css(div_skill + " table")[0].css("td").first
      title = title.nil? ? "" : title.text.strip

      info = @agent.page.parser.css(div_skill + " table")[1]
      info = info.nil? ? "" : info.text.strip.gsub("\r\r\r", "\r\r").gsub("\n\n\n", "\n\n").gsub("\r\r", "\r").gsub("\n\n", "\n")
      if info.length > 2000
        info1 = info[0..1999]
        info2 = info[2000..-1]
      else
        info1 = info
        info2 = ""
      end


      range = @agent.page.parser.css(div_skill + " div#rangecontainer").first
      range = range.nil? ? "" : range.text.strip


      cost = @agent.page.parser.css(div_skill + " div#costcontainer").first
      cost = cost.nil? ? "" : cost.text.strip

      cooldown = @agent.page.parser.css(div_skill + " div#cooldowncontainer").first
      cooldown = cooldown.nil? ? "" : cooldown.text.strip    

      abilities[ skill ] = { :title => title.gsub("\u00A0", ""), 
                             :info1 => info1.gsub("\u00A0", ""),
                             :info2 => info2.gsub("\u00A0", ""),
                             :range => range.gsub("\u00A0", ""),
                             :cost => cost.gsub("\u00A0", ""),
                             :cooldown => cooldown.gsub("\u00A0", "") }
    end
    abilities[:champ_name] = champ_name
    abilities[:link] = link
    return abilities
  rescue
    return {}
  end

end