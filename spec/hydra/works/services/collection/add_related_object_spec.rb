require 'spec_helper'

describe Hydra::Works::AddRelatedObjectToCollection do

  let(:subject) { Hydra::Works::Collection.new }

  describe '#call' do

    context 'with acceptable related objects' do
      let(:object1) { Hydra::PCDM::Object.new }
      let(:object2) { Hydra::PCDM::Object.new }
      let(:collection1) { Hydra::Works::Collection.new }
      let(:collection2) { Hydra::Works::Collection.new }
      let(:generic_work1) { Hydra::Works::GenericWork::Base.new }
      let(:generic_work2) { Hydra::Works::GenericWork::Base.new }
      let(:generic_file1) { Hydra::Works::GenericFile::Base.new }

      it 'should add various types of related objects to collection' do
        Hydra::Works::AddRelatedObjectToCollection.call( subject, generic_work1 )
        Hydra::Works::AddRelatedObjectToCollection.call( subject, generic_file1 )
        Hydra::Works::AddRelatedObjectToCollection.call( subject, object1 )
        related_objects = Hydra::Works::GetRelatedObjectsFromCollection.call( subject )
        expect( related_objects.include? generic_work1 ).to be true
        expect( related_objects.include? generic_file1 ).to be true
        expect( related_objects.include? object1 ).to be true
        expect( related_objects.size ).to eq 3
      end

      context 'with collections and generic_works' do
        before do
          Hydra::Works::AddCollectionToCollection.call( subject, collection1 )
          Hydra::Works::AddCollectionToCollection.call( subject, collection2 )
          Hydra::Works::AddGenericWorkToCollection.call( subject, generic_work1 )
          Hydra::Works::AddGenericWorkToCollection.call( subject, generic_work2 )
          Hydra::Works::AddRelatedObjectToCollection.call( subject, object1 )
        end

        it 'should add a related object to collection with collections and generic_works' do
          Hydra::Works::AddRelatedObjectToCollection.call( subject, object2 )
          related_objects = Hydra::Works::GetRelatedObjectsFromCollection.call( subject )
          expect( related_objects.include? object1 ).to be true
          expect( related_objects.include? object2 ).to be true
          expect( related_objects.size ).to eq 2
        end

        it 'should solrize member ids' do
          skip 'skipping this test because issue #109 needs to be addressed' do
          expect(subject.to_solr["generic_works_ssim"]).to include(generic_work1.id,generic_work2.id)
          expect(subject.to_solr["generic_works_ssim"]).not_to include(collection2.id,collection1.id,object1.id,object2.id)
          expect(subject.to_solr["collections_ssim"]).to include(collection2.id,collection1.id)
          expect(subject.to_solr["collections_ssim"]).not_to include(object1.id,object2.id,generic_work1.id,generic_work2.id)
          expect(subject.to_solr["related_objects_ssim"]).to include(object1.id,object2.id)
          expect(subject.to_solr["related_objects_ssim"]).not_to include(collection2.id,collection1.id,generic_work1.id,generic_work2.id)
        end
        end
      end
    end

    context 'with unacceptable child related objects' do
      let(:collection1)      { Hydra::Works::Collection.new }
      let(:pcdm_collection1) { Hydra::PCDM::Collection.new }
      let(:pcdm_file1)       { Hydra::PCDM::File.new }
      let(:non_PCDM_object)  { "I'm not a PCDM object" }
      let(:af_base_object)   { ActiveFedora::Base.new }

      let(:error_message) { 'child_related_object must be a pcdm object' }

      it 'should NOT aggregate Hydra::Works::Collection in related objects aggregation' do
        expect{ Hydra::Works::AddRelatedObjectToCollection.call( subject, collection1 ) }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT aggregate Hydra::PCDM::Collections in related objects aggregation' do
        expect{ Hydra::Works::AddRelatedObjectToCollection.call( subject, pcdm_collection1 ) }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT aggregate Hydra::PCDM::Files in related objects aggregation' do
        expect{ Hydra::Works::AddRelatedObjectToCollection.call( subject, pcdm_file1 ) }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT aggregate non-PCDM objects in related objects aggregation' do
        expect{ Hydra::Works::AddRelatedObjectToCollection.call( subject, non_PCDM_object ) }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT aggregate AF::Base objects in related objects aggregation' do
        expect{ Hydra::Works::AddRelatedObjectToCollection.call( subject, af_base_object ) }.to raise_error(ArgumentError,error_message)
      end
    end

    context 'with invalid behaviors' do
      let(:object1) { Hydra::PCDM::Object.new }
      let(:object2) { Hydra::PCDM::Object.new }

      it 'should NOT allow related objects to repeat' do
        skip 'skipping this test because issue pcdm#92 needs to be addressed' do
        Hydra::Works::AddRelatedObjectToCollection.call( subject, object1 )
        Hydra::Works::AddRelatedObjectToCollection.call( subject, object2 )
        Hydra::Works::AddRelatedObjectToCollection.call( subject, object1 )
        related_objects = Hydra::Works::GetRelatedObjectsFromCollection.call( subject )
        expect( related_objects.include? object1 ).to be true
        expect( related_objects.include? object2 ).to be true
        expect( related_objects.size ).to eq 2
      end
      end
    end
  end
end
