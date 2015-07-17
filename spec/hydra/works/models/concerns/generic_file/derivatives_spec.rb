require 'spec_helper'

describe Hydra::Works::GenericFile::Derivatives do
  

  it "uses the Hydra::Works::PersistDerivative service" do
    expect(Hydra::Derivatives.output_file_service).to eq(Hydra::Works::PersistDerivative)
  end

  describe 'thumbnail generation' do
    before do
      #Hydra::Works::AddFileToGenericFile.call(generic_file, File.join(fixture_path, file_name), :original_file)
      Hydra::Works::UploadFileToGenericFile.call(generic_file, File.join(fixture_path, file_name)) #, :original_file)
      allow_any_instance_of(Hydra::Works::GenericFile::Base).to receive(:mime_type).and_return(mime_type)
      generic_file.save!
    end
    context 'with a video (.avi) file', unless: $in_travis do
      let(:mime_type) { 'video/avi' }
      let(:file_name) { 'countdown.avi' }
      let(:generic_file) { Hydra::Works::GenericFile::Base.create }

      it 'lacks a thumbnail' do
        expect(generic_file.thumbnail).to be_nil
      end

      it 'generates a thumbnail derivative' do
        #expect(generic_file).to receive(:create_derivatives)
        generic_file.create_derivatives
        expect(generic_file.thumbnail).to have_content
        expect(generic_file.thumbnail.mime_type).to eq('image/jpeg')
      end
    end

    context 'with an image file', unless: $in_travis do
      let(:mime_type) { 'image/png' }
      let(:file_name) { 'world.png' }
      let(:generic_file) { Hydra::Works::GenericFile::Base.create }

      it 'lacks a thumbnail' do
        expect(generic_file.thumbnail).to be_nil
      end

      it 'generates a thumbnail derivative' do
        #expect(generic_file).to receive(:create_derivatives)
        generic_file.create_derivatives
        byebug
        expect(generic_file.thumbnail).to have_content
        expect(generic_file.thumbnail.mime_type).to eq('image/jpeg')
      end
    end

    context 'with an audio (.wav) file', unless: $in_travis do
      let(:mime_type) { 'audio/wav' }
      let(:file_name) { 'piano_note.wav' }
      let(:generic_file) { Hydra::Works::GenericFile::Base.create }

      it 'lacks a thumbnail' do
        expect(generic_file.thumbnail).to be_nil
      end

      it 'does not generate a thumbnail when derivatives are created' do
        generic_file.create_derivatives
        expect(generic_file.thumbnail).to be_nil
      end
    end

    context 'with an image (.jp2) file' do
      let(:mime_type) { 'image/jp2' }
      let(:file_name) { 'image.jp2' }
      let(:generic_file) { Hydra::Works::GenericFile::Base.create }

      it 'lacks a thumbnail' do
        expect(generic_file.thumbnail).to be_nil
      end

      it 'generates a thumbnail on job run' do
        generic_file.create_derivatives
        expect(generic_file.thumbnail).to have_content
        expect(generic_file.thumbnail.mime_type).to eq('image/jpeg')
      end
    end

    context 'with an office document (.docx) file', unless: $in_travis do
      let(:mime_type) { 'application/vnd.openxmlformats-officedocument.wordprocessingml.document' }
      let(:file_name) { 'charter.docx' }
      let(:generic_file) { Hydra::Works::GenericFile::Base.create }

      it 'lacks a thumbnail' do
        expect(generic_file.thumbnail).to be_nil
      end

      it 'generates a thumbnail on job run' do
        generic_file.create_derivatives
        expect(generic_file.thumbnail).to have_content
        expect(generic_file.thumbnail.mime_type).to eq('image/jpeg')
      end
    end
  end
end