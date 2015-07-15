module Hydra::Works::GenericFile
  module Derivatives
    extend ActiveSupport::Concern
    
    included do
      include Hydra::Derivatives

      Hydra::Derivatives.output_file_service = Hydra::Works::PersistDerivative

      # This was taken directly from Sufia's GenericFile::Derivatives and modified to exclude any processing that modified the original file
      makes_derivatives do |obj|
        case obj.mime_type
        when *pdf_mime_types
          obj.transform_file :original_file, { thumbnail: { format: 'jpg', size: '338x493' } }, processor: :work
        when *office_document_mime_types
          obj.transform_file :original_file, { thumbnail: { format: 'jpg', size: '200x150>' } }, processor: :document
        when *video_mime_types
          obj.transform_file :original_file, { thumbnail: { format: 'jpg' } }, processor: :video
        when *image_mime_types
          obj.transform_file :original_file, { thumbnail: { format: 'jpg', size: '200x150>' } }, processor: :work
        end
        
      end

    end

    # This bit was not in Sufia, but needs to be here for derivatives to work
    # TODO: delegate mime type somewhere else?
    def mime_type
      return nil unless self.original_file
      self.original_file.mime_type
    end

  end
end
