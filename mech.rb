require "mechanize"

class Mech
  def initialize
    @agent = Mechanize.new
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

end