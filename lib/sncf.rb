require 'net/http'
require 'rexml/document'

module Sncf
  class XmlDoc 
    def initialize(url)
      @url = url
    end

    def get_doc
      doc = REXML::Document.new(get_data)
    end
    
    private

    def get_data
      Net::HTTP.get_response(URI.parse(@url)).body
    end
  end

  class NextDeparture
    URL = 'http://ms.api.ter-sncf.com/?action=nextdeparture&stopareaexternalcode='
    
    def get_next_departure(stop_area)
      REXML::Document.new(Net::HTTP.get_response(URI.parse(URL + stop_area)).body).elements['//Stop'].each do |stop|
      # XmlDoc.new(URL + stop_area).get_doc.elements['//Stop'].each do |stop|  
        vehicleName = stop.elements['StopTime'].class
        # vehicleName = "N°" + stop.elements['VehicleJourney'].attributes['VehicleJourneyName'] 
        # vehicleName << " " + stop.elements['VehicleJourney/Route/Line/ModeType'].attributes['ModeTypeName']
        # vehicleName << " | " + stop.elements['VehicleJourney/Route'].attributes['RouteName']
        # vehicleName << " | " + stop.elements['StopTime/Hour'].text + "h" + stop.elements['StopTime/Minute'].text + "m"
        puts vehicleName
      end
    end
  end
end

include Sncf
NextDeparture.new.get_next_departure('OCE87574194')
