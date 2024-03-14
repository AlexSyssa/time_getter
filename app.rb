require 'rack'
require_relative 'time_getter'

class App

  CORRECT_URL = '/time'.freeze
  PARAMS_KEY = 'format'.freeze

  def call(env)
    request = Rack::Request.new(env)
    params = request.params[PARAMS_KEY]
    if url_correct?(env['REQUEST_PATH']) && request.get?
      check_params(params)
    else
      response(404, 'Incorrect url')
    end
  end

  private

  def url_correct?(url)
    url == CORRECT_URL
  end

  def response(status, body)
    Rack::Response.new(body, status, { 'Content-Type' => 'text/plain' }).finish
  end

  def check_params(params)
    time_format = TimeFormat.new(params)
    time_format.call
    if time_format.success?
      response(200, time_format.time_text)
    else
      response(400, time_format.invalid_params)
    end
  end
end
