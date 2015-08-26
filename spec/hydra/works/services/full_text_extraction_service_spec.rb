require 'spec_helper'

describe Hydra::Works::FullTextExtractionService do
  let(:generic_file) { FactoryGirl.create(:generic_file) }

  describe "#run" do
    let(:service_instance) { double() }
    it "creates an instance of the service and calls .extract on it" do
      expect(described_class).to receive(:new).with(generic_file).and_return(service_instance)
      expect(service_instance).to receive(:extract)
      described_class.run(generic_file)
    end
  end

  describe "extract", unless: $in_travis do



    subject   { described_class.new(generic_file) }
    before do
      Hydra::Works::UploadFileToGenericFile.call(generic_file, File.open(fixture_file_path('charter.docx')))
    end
    it "extracts fulltext and stores the results" do


      expect(subject).to receive(:extract_fulltext).and_return("The fulltext")
      #subject.characterize
      #expect(generic_file.mime_type).to eq 'application/vnd.oasis.opendocument.text'
      expect(generic_file.filename).to eq 'charter.docx'
      expect(generic_file.extracted_text.content).to eq "The fulltext"
    end
  end

end
