require 'rack'
require_relative 'app'

class TimeFormat

  TIME_FORMATS = { year: '%Y', month: '%m', day: '%d', hour: '%H', minute: '%M', second: '%S' }.freeze

  def initialize(params)
    @params = params.split(',')
    @time_string = []
    @unknown_formats = []
  end

  def call
    @params.each do |format|
      if TIME_FORMATS.key?(format.to_sym)
        @time_string << TIME_FORMATS[format.to_sym]
      else
        @unknown_formats << format
      end
    end
  end

  def success?
    @unknown_formats.empty?
  end

  def time_text
    Time.now.strftime(@time_string.join('-'))
  end

  def invalid_params
    "Unknown time format #{@unknown_formats.join(', ')}"
  end

end
