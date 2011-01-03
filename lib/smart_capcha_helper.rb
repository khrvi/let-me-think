module LetMeThink
  module SmartCapchaHelper
    def smart_capcha
      result = ''
      result << "<span id='smart_capcha'>"
      result << "<label for='captcha_answer'>"
      result << "Spam protection: #{@captcha}</label>"
      result << text_field_tag(:captcha_answer, params[:captcha_answer], :size => 30)
      result << "</span>"
      result.html_safe
    end
  end
end
ActionController::Base.helper LetMeThink::SmartCapchaHelper