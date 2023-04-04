
require "open-uri"
require "json"
require 'cgi'

##### Get user input 
p "Do you need an umbrella today? Enter your location."
user_loc = gets.chomp
user_loc_parse = CGI.escape(user_loc) #make special chars URL friendly

##### get lat / long
gmaps_endpoint = URI.open("https://maps.googleapis.com/maps/api/geocode/json?address=#{user_loc_parse}&key=#{ENV.fetch("GMAPS_KEY")}") 

gmaps_parse = JSON.parse(gmaps_endpoint.read)
location =  gmaps_parse["results"][0]["geometry"]["location"]
gmaps_lat = location["lat"]
gmaps_lng = location["lng"]

p location

##### get weather  
pirate_endpoint = URI.open("https://api.pirateweather.net/forecast/#{ENV.fetch("PIRATE_WEATHER_KEY")}/#{gmaps_lat},#{gmaps_lng}")

pirate_parse = JSON.parse(pirate_endpoint.read)

current_temp = pirate_parse["currently"]["temperature"]
current_weather = pirate_parse["currently"]["summary"]
hourly_weather = pirate_parse["hourly"]["data"]

##### return forecast to user 

#current weather
p "The current temperature is #{current_temp}F and the current weather is #{current_weather.downcase}."

#next 12 hrs 
hourly_weather.each do |hour_forecast|
  hour_time = Time.at(hour_forecast["time"])  
  hour_time_format = hour_time.strftime("%I %p") 
  chance_rain = hour_forecast["precipProbability"

  p hour_time_format
end 
