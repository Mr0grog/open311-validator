

class Response
  
  def initialize(url)
    @raw = HTTParty.get(url)
  end
  
  def response
    Response.hash2ostruct(@raw.parsed_response)
  end
  
  def headers
    Response.hash2ostruct(@raw.headers)
  end
  
  def body
    @raw.body
  end
  
  def request
    @raw.request
  end
  
  # Recursively create ostruct obj from 
  # httparty's Hash/Array mess.
  def self.hash2ostruct(object)
    return case object
    when Hash
      object = object.clone
      object.each do |key, value|
        object[key] = Response.hash2ostruct(value)
      end
      OpenStruct.new(object)
    when Array
      object = object.clone
      object.map! { |i| Response.hash2ostruct(i) }
    else
      object
    end
  end
  
end