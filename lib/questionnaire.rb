require 'humane_integer'

 # Simple model to hold sets of questions and answers.
class Questionnaire
  
  def initialize
    file = File.join(Rails.root, "config/questionnaire.yml")
    @@config ||= YAML::load(File.open(file))
  rescue
    raise "Config file is not found"
  end

  # Attempt to answer a captcha, returns true if the answer is correct.
  def self.attempt?(string, answer)
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
    questions = @@config['questions'][I18n.locale.to_s]
    q = questions.keys[rand(questions.size)].dup
    interval = (@@config['interval'] || 50).to_i
    formula = questions[q]
    first_number = rand(interval)
    last_number = rand(interval)
    formula.gsub!('$1', first_number)
    formula.gsub!('$2', last_number)
    result = eval(formula)
    q.gsub!('$1', HumaneInteger.new(first_number).to_english)
    q.gsub!('$2', HumaneInteger.new(last_number).to_english)
    [q, result]
  end

  def answer_is_integer?
    int_answer = answer.to_i
    (int_answer != 0) || (int_answer == 0 && answer == "0")
  end
end