
module DiscoveryHelper
  
  def xml_endpoints
    @resource.xml.response.discovery.endpoints.endpoint
  end
  
  def json_endpoints
    @resource.json.response.endpoints
  end
  
  def all_endpoints
    xml_endpoints + json_endpoints
  end
  
  def v2_endpoints
    all_endpoints.select{|endpoint| endpoint.specification =~ /^.*_v2$/i }
  end
  
  def xml_discovery
    @resource.xml.response.discovery
  end
  
  def json_discovery
    @resource.json.response
  end
  
  def endpoint_array(point)
    if point.formats.class == Array
      point.formats
    elsif point.formats.format.class == Array
      point.formats.format
    else
      []
    end
  end
  
  extend self
end