module Hydra::Works
  class ImportableFile < File

    attr_accessor :payload, :mime_type, :original_file

    def initialize(payload, mime_type, original_file)
      @payload = payload
    end

    # need to respond to something 
    def read
      if "is a file"
        payload.read
      else 
        payload
      end
    end

  end
end