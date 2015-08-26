require 'spec_helper'

describe Hydra::Works::FullTextExtractionService do
 
  #let(:generic_file) { Hydra::Works::GenericFile::Base.new }

  #let(:thumbnail) do
  #  file = generic_file.files.build
  #  Hydra::PCDM::AddTypeToFile.call(file, pcdm_thumbnail_uri)
  #end

 describe "extract pdf file" do
    before do
      #@myfile = Hydra::Works::GenericFile::Base.create { |gf| gf.apply_depositor_metadata('blah') }
      @myfile = Hydra::Works::GenericFile::Base.create
      #Hydra::Works::AddFileToGenericFile.call(@myfile, File.open(fixture_file_path('test4.pdf')), :original_file)
      Hydra::Works::AddFileToGenericFile.call(@myfile, File.open(File.join(fixture_path, 'test4.pdf')), :original_file)

      Hydra::Works::FullTextExtractionService.run(@myfile)
    end

    it "returns expected results after a save" do
      expect(@myfile.file_size).to eq ['218882']
      expect(@myfile.original_checksum).to eq ['5a2d761cab7c15b2b3bb3465ce64586d']

      expect(@myfile.title).to include("Microsoft Word - sample.pdf.docx")
      expect(@myfile.filename).to eq 'test4.pdf'

      expect(@myfile.format_label).to eq ["Portable Document Format"]
      expect(@myfile.title).to include("Microsoft Word - sample.pdf.docx")
      expect(@myfile.extracted_text.content).to eq("\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nMicrosoft Word - sample.pdf.docx\n\n\n \n \n\n \n\n \n\n \n\nThis PDF file was created using CutePDF. \n\nwww.cutepdf.com")
    end
  end

  describe "m4a" do
    before do
      #@myfile = Hydra::Works::GenericFile::Base.create { |gf| gf.apply_depositor_metadata('blah') }
      #Hydra::Works::AddFileToGenericFile.call(@myfile, File.open(fixture_file_path('spoken-text.m4a')), :original_file)
      @myfile = Hydra::Works::GenericFile::Base.create
      # characterize method saves
      Hydra::Works::AddFileToGenericFile.call(@myfile, File.open(File.join(fixture_path, 'spoken-text.m4a')), :original_file)
      Hydra::Works::FullTextExtractionService.run(@myfile)

    end

    it "returns expected content for full text" do
      expect(@myfile.extracted_text.content).to eq("\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nLavf56.15.102")
    end
  end
end
