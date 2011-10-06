
class Session
  attr_accessor :options
  
  def initialize(options)
    @resources = []
    @options   = options
  end
  
  def resources
    @resources
  end
  
  def discovery
    @resources.first
  end
  
  def resource
    @resources.last
  end
  
  def prev_resource
    @resources[@resources.count-2]
  end
  
  def add_resource(options)
    resource = Resource.new(self,@options.merge(options))
    resource.get_next
    @resources << resource
  end
  
  def run_tests
    load 'tests/discovery.rb'
#  endpoints
    load 'tests/services.rb'
    load 'tests/service_definition.rb'
    #load 'tests/create.rb' if @options[:write]
  end
  
  #
  #    :url => format
  #
  def endpoints
    t = []
    # We need to handle json and xml differently because xml sucks and can't be parsed predictably.
    json_endpoints.each do |endpoint|
      endpoint.formats.each do |format|
        next if format =~ /^.*html$/i
        t << [endpoint.url,format.to_s.split('/')[1]]
      end
    end
    xml_endpoints.each do |endpoint|
      Session.ensure_array(Session.unwrap(endpoint,'formats.format')).each do |format|
        next if format =~ /^.*html$/i
        t << [endpoint.url,format.to_s.split('/')[1]]
      end
    end
    t
  end
  
  def services
    @resources[1].raw.map{|r| r.response }.flatten
  end
  
  def raw_services
    @resources[1].raw
  end
  
  def all_endpoints
    json_endpoints + xml_endpoints
  end
  
  def json_endpoints
    Session.unwrap(discovery.raw.json, 'response.endpoints').select{|endpoint| production_safe?(endpoint) }
  end
  
  def production_safe?(endpoint)
    type(endpoint) != 'production' or @options[:production]
  end
  
  def xml_endpoints
    Session.ensure_array(Session.unwrap(discovery.raw.xml,'response.discovery.endpoints.endpoint')).select{|endpoint| production_safe?(endpoint) }
  end
  
  def self.unwrap(obj,methods)
    methods.split('.').each do |method|
      obj = obj.send method.to_sym
    end
    obj
  end
  
  def self.ensure_array(result)
    result.is_a?(Array) ? result : [result]
  end
  
  private
  
  def type(endpoint)
    endpoint.marshal_dump[:type]
  end
  
end