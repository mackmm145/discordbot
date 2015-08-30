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

  def get_card(name)
    @agent.get("http://www.hearthpwn.com/cards?display=3&filter-name=" + name.gsub(" ", "+"))
    cards = @agent.page.parser.css("div.card-image-item img")
    card_src = []
    unless cards.nil?
      cards.each { |card| card_src << card.attributes["src"] }
    end
    
    return card_src
  end
 
end