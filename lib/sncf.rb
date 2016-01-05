require 'net/http'
require 'rexml/document'
require 'csv'

module Sncf
  class Journey
    #Open API Ter SNCF
	URL = 'http://ms.api.ter-sncf.com'

    %i(departure arrival).each do |method|
      define_method("get_next_#{method}") do |city|
        matches = city_search(city)

        if matches.count > 1 then
          puts "Modify your parameter and choose only one external code or city name"
          show_city(matches)
        elsif matches.count == 0
          puts "Modify your parameter. We are not able to find a city with such that name"  
        else
          puts "#{method.capitalize}s for #{matches[0][1]} (#{matches[0][0]})"
          call_api("next#{method}", "stopareaexternalcode=OCE87#{matches[0][0]}", "//Stop") do |stop|
            puts build_journey_results(stop, method)
          end
        end
      end
    end

    private

    def city_search(city)
      CSV.open('lib/data', 'r') do |data|
        matches = data.find_all do |row|
          row[0].include? city or row[1].include? city
        end
      end
    end

    def show_city(matches)
      matches.sort_by { |row| row[1] }.each do |result|
        puts "#{result[0]} | #{result[1]}"
      end 
    end

    def build_area_results(area)
      "#{area.get_attribute('', 'StopAreaName').capitalize}"\
        " | #{area.get_attribute('', 'StopAreaExternalCode')}"
    end

    def build_journey_results(stop, method)
      "N°%-6s | %-10s | %-45s | %-2sh%-2sm" % 
        [
          stop.get_attribute('VehicleJourney', 'VehicleJourneyName'),
          stop.get_attribute('VehicleJourney/Route/Line/ModeType','ModeTypeName'),
          stop.get_attribute('VehicleJourney/Route','RouteName')[0,45],
          stop.get_text(time_node(method) + "Hour"),
          stop.get_text(time_node(method) + "Minute")
        ]
    end

    def time_node(method)
      "Stop" + (method == :arrival ? "Arrival" : "") + "Time/"
    end

    def call_api(action, parameters, type)
      XmlDocument.new(get_api_url(action, parameters)).get_elements(type) do |node|
        yield node
      end
    end
    
    def get_api_url(action, parameters)
      "#{URL}/?action=#{action.to_s}&#{parameters}"
    end
  end

  class XmlElement < REXML::Element
    def initialize(element)
      @element = element
    end

    def get_attribute(root, attribute)
      get_element(root).attributes[attribute]
    end

    def get_text(root)
      get_element(root).text
    end
 
    def get_element(root)
      @element.elements[root]
    end
  end

  class XmlDocument 
    def initialize(url)
      @url = url
    end

    def get_elements(root)
      get_doc.elements.each(root) do |element|
        yield XmlElement.new(element)
      end      
    end

    private

    def get_doc
      REXML::Document.new(get_data)
    end
    
    def get_data
      Net::HTTP.get_response(URI.parse(@url)).body
    end
  end
end
