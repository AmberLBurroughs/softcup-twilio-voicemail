require 'pry'
require 'sinatra'
require 'sinatra/base'
require 'sinatra/cross_origin'
require 'rubygems'
require 'twilio-ruby'

get '/softcup-twilio-voicemail' do
  Twilio::TwiML::Response.new do |r|
  	# r.Play 'http://demo.twilio.com/hellomonkey/monkey.mp3' voice recording here
    r.Say 'Thank you for calling Softcup. Your call is very important to us. Leave a message and we will get back to you as soon as we can.'
  	r.Gather :numDigits => '1', :action => '/softcup-twilio-voicemail/handle-gather', :method => 'get' do |g|
      g.Say 'To record a voicemail, press 1.'
      g.Say 'To Speak with someone at The Flex Company, press 2.'
      g.Say 'Press 3 to end this call.'
 	end
  end.text
end

get '/softcup-twilio-voicemail/handle-gather' do
  redirect '/softcup-twilio-voicemail' unless ['1', '2'].include?(params['Digits'])
  if params['Digits'] == '1'
    response = Twilio::TwiML::Response.new do |r|
      r.Say 'Record your message after the tone.'
      r.Record :maxLength => '30', :action => '/softcup-twilio-voicemail/handle-record', :method => 'get'
    end
  elsif params['Digits'] == '2'
  	response = Twilio::TwiML::Response.new do |r|
      r.Dial '+18009310882'
      r.Say 'The call failed or the remote party hung up. Goodbye.'
    end
  elsif params['Digits'] == '3'
    response = Twilio::TwiML::Response.new do |r|
      r.Say 'Goodbye'
      r.Hangup
    end
  end
  response.text
end

get '/softcup-twilio-voicemail/handle-record' do
  Twilio::TwiML::Response.new do |r|
       r.Say 'Thank you, Goodbye.'
  end.text
end
