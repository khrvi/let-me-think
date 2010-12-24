require 'humane_integer'

 # Simple model to hold sets of questions and answers.
class Questionnaire
  
  def initialize
    file = File.join(Rails.root, "config/questionnaire.yml")
    @@config ||= YAML::load(File.open(file))
  rescue
    raise "Config file is not found"
  end
  
  # def config
  #     @config ||= YAML::load(File.open(file))
  #   end

  # Attempt to answer a captcha, returns true if the answer is correct.
  def self.attempt?(string, answer)
    puts "!!!!#{answer}!!"
    string = string.strip.downcase
    if answer_is_integer?
      return string == answer || string == HumaneInteger.new(answer.to_i).to_english
    else
      return string == answer.downcase
    end
  end

  def self.find_random_question
    find_random
  end

  private

  def self.find_random
    #find(:first, :conditions => ['locale = ?', I18n.locale.to_s], :order => random_function)
    questions = @@config['questions'][I18n.locale.to_s]
    q = questions[rand(questions.size)]
    interval = (@@config['interval'] || 50).to_i
    first_number = rand(interval)
    last_number = rand(interval)
    result = first_number + last_number
    q.gsub('$1', HumaneInteger.new(first_number).to_english)
    q.gsub('$2', HumaneInteger.new(last_number).to_english)
    [q, result]
  end

  # def self.find_specific_or_fallback(id)
  #   find(id)
  # rescue ActiveRecord::RecordNotFound
  #   find_random
  # end

  def answer_is_integer?
    int_answer = answer.to_i
    (int_answer != 0) || (int_answer == 0 && answer == "0")
  end

end