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

end