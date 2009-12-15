require 'rubygems'
require 'sinatra'
require 'activesupport'
require 'haml'

get '/' do
  year = (params[:year]) ? params[:year] : Time.now.year
  @time = Time.mktime(year, "jan", 1, 1, 00, 00)
  haml :index
end