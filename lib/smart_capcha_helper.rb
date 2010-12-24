module LetMeThink
  module SmartCapchaHelper
    def smart_capcha
      result = ''
      result << "<span id='smart_capcha' class='#{if last_captcha_attempt_failed? then 'captcha_failed' end }'>"

      result << hidden_field_tag(:captcha_id, @captcha.id)
      result << "<label for='captcha_answer'><label for='captcha_answer'>"
      result << "Spam protection: #{@captcha.question }</label>"

      result << text_field_tag(:captcha_answer, params[:captcha_answer], :size => 10, :maxlength => 40)

      result << "</span>"
    end
  end
end
ActionController::Base.helper LetMeThink::SmartCapchaHelper