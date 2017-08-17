require 'sinatra'
require 'alexa_skills_ruby'

class CustomHandler < AlexaSkillsRuby::Handler

  on_launch do
    response.set_output_speech_text("Welcome. I hope you enjoyed the cruise. You can ask me to say Hello to Jason Issacs.")
    response.set_simple_card("Welcome", "I hope you enjoyed the cruise. You can ask me to say Hello to Jason Issacs.")
    session_attributes = { should_end_session => false }
    logger.info 'Launch processed'
  end

  on_intent("HelloToJason") do
    slots = request.intent.slots
    response.set_output_speech_text("Hello to Jason Issacs")
    #response.set_output_speech_ssml("<speak><p>Horoscope Text</p><p>More Horoscope text</p></speak>")
    response.set_reprompt_speech_text("Did you want to say hello to Jason Issacs?")
    #response.set_reprompt_speech_ssml("<speak>Reprompt Horoscope Text</speak>")
    response.set_simple_card("Hello!", "Hello to Jason Issacs.")
    logger.info 'HelloToJason processed'
  end

end

post '/' do
  content_type :json

  handler = CustomHandler.new(application_id: ENV['APPLICATION_ID'], logger: logger)

  begin
    hdrs = { 'Signature' => request.env['HTTP_SIGNATURE'], 'SignatureCertChainUrl' => request.env['HTTP_SIGNATURECERTCHAINURL'] }
    handler.handle(request.body.read, hdrs)
  rescue AlexaSkillsRuby::Error => e
    logger.error e.to_s
    403
  end

end
