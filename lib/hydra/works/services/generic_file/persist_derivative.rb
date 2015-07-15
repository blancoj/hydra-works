require 'hydra/derivatives'

module Hydra::Works
  class PersistDerivative < Hydra::Derivatives::PersistOutputFileService

    ##
    # Persists a derivative to a GenericFile
    # This Service conforms to the signature of `Hydra::Derivatives::PersistOutputFileService`.  
    # The purpose of this Service is for use as an alternative to the default Hydra::Derivatives::PersistOutputFileService.  It's necessary because the default behavior in Hydra::Derivatives assumes that you're using LDP Basic Containment. Hydra::Works::GenericFiles use IndirectContainment.  This Service handles that case.
    # 
    # @param [Hydra::Works::GenericFile::Base] object the file will be added to
    # @param [File] file the derivative filestream
    # @param [String] destination_name path to the file
    # @option opts [RDF::URI or String] type URI for the RDF.type that identifies the file's role within the generic_file
    # @option opts [Boolean] update_existing when set to false, always adds a new file.  When set to true, performs a create_or_update
    # @option opts [Boolean] versioning whether to create new version entries

    def self.call(object, file, destination_name, opts={})
      type = opts.fetch(:type, ::RDF::URI("http://pcdm.org/use#ServiceFile"))
      update_existing = opts.fetch(:update_existing, true)
      versioning = opts.fetch(:versioning, true)
      # Tmpfile should be removed when https://github.com/projecthydra-labs/hydra-works/issues/118 is resolved
      tempfile = File.new("/tmp/foo", 'w+')
      tempfile.write(file)
      Hydra::Works::AddFileToGenericFile.call(object, tempfile.path, destination_name, update_existing: update_existing, versioning: versioning)
      File.delete(tempfile)
    end

  end
end
