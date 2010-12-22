class QuestionnaireConfigGenerator < Rails::Generator::Base
  def manifest
    record do |m|
      m.file "config/questionnaire.yml", "config/questionnaire.yml"
      m.readme "../../../README"
    end
  end
end