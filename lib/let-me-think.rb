require 'digest/sha2'
require 'questionnaire'
require 'smart_capcha_helper'
module LetMeThink

  def self.included(obj)
    obj.class_eval do
      @@smart_capcha_salt ||= "fGr0FXmYQCuW4TiQj/x3yPBTp5lcJ9l6DbO8CUpReDk="
      @@smart_capcha_failure_message = "Your captcha answer failed - please try again."
      cattr_accessor :smart_capcha_salt, :smart_capcha_failure_message
    end
  end

  def create_smart_capcha
    cookies[:capcha_action] = params[:action]
    Questionnaire.new
    @captcha = find_question
  end

  def validate_smart_capcha
    return captcha_failure unless (params[:captcha_answer])
    is_success = captcha_passed?
    return is_success ? captcha_success : captcha_failure
  end
  
  def self.encrypt(str, salt)
    Digest::SHA256.hexdigest("--#{str}--#{salt}--")
  end

  def captcha_passed?
    cookies[:captcha_status] == encrypt(params[:captcha_answer])
  end

  protected

  def captcha_success
    true
  end

  def captcha_failure
    set_captcha_failure_message
    render_or_redirect_for_captcha_failure
  end

  def render_or_redirect_for_captcha_failure
    redirect_to :controller => self.controller_name, :action => cookies[:capcha_action]
  end

  def set_captcha_failure_message
    flash[:error] = smart_capcha_failure_message
  end

  def find_question
    result = Questionnaire.find_random_question
    cookies[:captcha_status] = encrypt(result[1])
    result[0]
  end

  private

  def encrypt(str)
    LetMeThink.encrypt(str, smart_capcha_salt)
  end
end
ActionController::Base.class_eval { include LetMeThink }