# frozen_string_literal: true

require 'rails_helper'
require 'swagger_helper'

RSpec.describe 'Speeches API', type: :request do
  let!(:current_user) { create(:user) }

  let!(:login_credentials) { login }
  let(:Authorization) { login_credentials['Authorization'] }

  path '/speeches' do
    get 'Fetch speech list' do
      security [bearer: []]
      tags 'Speech'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :query, in: :query, type: :string, nullable: true
      parameter name: :date_filter, in: :query, type: :string, nullable: true

      response '200', 'list fetched' do
        let!(:current_user) { create(:user, email: 'test@sample.com') }
        let!(:new_speech) { create(:speech, user: current_user) }
        let!(:query) { '' }
        let!(:date_filter) { '' }
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data.first['content']).to eq(new_speech.content)
          expect(data.first['keywords']).to eq(new_speech[:keywords])
          expect(data.first['speech_date']).to eq('10/14/2022')
          expect(data.first['author']).to eq(new_speech[:author])
        end
      end

      response '200', 'list based on query' do
        let!(:current_user) { create(:user, email: 'test@sample.com') }
        let!(:new_speech) { create(:speech, user: current_user, content: 'lorem ipsum', author: 'lorem') }
        let!(:new_speech_two) do
          create(:speech, user: current_user, content: 'hello world this is a test', author: 'hello')
        end
        let!(:query) { 'test' }
        let!(:date_filter) { '' }
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data.length).to eq(1)
          expect(data.first['content']).to eq(new_speech_two[:content])
          expect(data.first['keywords']).to eq(new_speech_two[:keywords])
          expect(data.first['speech_date']).to eq('10/14/2022')
          expect(data.first['author']).to eq(new_speech_two[:author])
        end
      end

      response '200', 'list based on date_filter' do
        let!(:current_user) { create(:user, email: 'test@sample.com') }
        let!(:new_speech) do
          create(:speech, user: current_user, content: 'lorem ipsum', author: 'lorem', speech_date: '10/15/2022')
        end
        let!(:new_speech_two) do
          create(:speech, user: current_user, content: 'hello world this is a test', author: 'hello',
                          speech_date: 'October 5, 2022')
        end
        let!(:query) { '' }
        let!(:date_filter) { 'October 15, 2022' }
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data.length).to eq(1)
          expect(data.first['content']).to eq(new_speech[:content])
          expect(data.first['keywords']).to eq(new_speech[:keywords])
          expect(data.first['speech_date']).to eq('10/15/2022')
          expect(data.first['author']).to eq(new_speech[:author])
        end
      end
    end

    post 'Creates a speech' do
      security [bearer: []]
      tags 'Speech'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :speech, in: :body, schema: {
        type: :object,
        properties: {
          content: { type: :string },
          speech_date: { type: :string, nullable: true },
          keywords: {
            type: :array,
            items: { type: :string },
            nullable: true
          },
          author: { type: :string, nullable: true }
        },
        required: %w[content]
      }

      response '200', 'speech created' do
        let(:speech) do
          {
            content: 'test speech',
            speech_date: '10/14/2022',
            keywords: %w[test speech],
            author: 'the author'
          }
        end
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['content']).to eq(speech[:content])
          expect(data['keywords']).to eq(speech[:keywords].join(','))
          expect(data['speech_date']).to eq(speech[:speech_date])
          expect(data['author']).to eq(speech[:author])
        end
      end

      response '422', 'invalid request' do
        let(:speech) do
          {
            author: 'the author'
          }
        end
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['status']).to eq(false)
        end
      end
    end
  end

  path '/speeches/{id}' do
    get 'Fetch a speech' do
      security [bearer: []]
      tags 'Speech'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :id, in: :path, type: :string

      response '200', 'speech updated' do
        let(:id) { create(:speech, user: current_user).id }
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['id']).to eq(id)
        end
      end

      response '404', 'invalid {id}' do
        let(:id) { '123' }
        run_test!
      end
    end

    delete 'Delete a speech' do
      security [bearer: []]
      tags 'Speech'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :id, in: :path, type: :string

      response '200', 'speech updated' do
        let(:id) { create(:speech, user: current_user).id }
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['status']).to eq('Ok')
          expect(Speech.where(id:).count).to eq(0)
        end
      end

      response '404', 'invalid {id}' do
        let(:id) { '123' }
        run_test!
      end
    end

    put 'Update a speech' do
      security [bearer: []]
      tags 'Speech'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :id, in: :path, type: :string
      parameter name: :speech, in: :body, schema: {
        type: :object,
        properties: {
          content: { type: :string },
          speech_date: { type: :string, nullable: true },
          keywords: {
            type: :array,
            items: { type: :string },
            nullable: true
          },
          author: { type: :string, nullable: true }
        },
        required: %w[content]
      }

      response '200', 'speech updated' do
        let(:id) { create(:speech, user: current_user).id }
        let(:speech) do
          {
            content: 'test speech 123',
            speech_date: '10/16/2022',
            keywords: %w[updated speech],
            author: 'the author is updated'
          }
        end
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['content']).to eq(speech[:content])
          expect(data['keywords']).to eq(speech[:keywords].join(','))
          expect(data['speech_date']).to eq(speech[:speech_date])
          expect(data['author']).to eq(speech[:author])
        end
      end

      response '422', 'invalid speech' do
        let(:id) { create(:speech, user: current_user).id }
        let(:speech) do
          {
            content: '',
            speech_date: '10/16/2022',
            keywords: %w[updated speech],
            author: 'the author is updated'
          }
        end
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['status']).to eq(false)
        end
      end

      response '404', 'invalid {id}' do
        let(:id) { '123' }
        let(:speech) do
          {
            content: 'test speech 123',
            speech_date: '10/16/2022',
            keywords: %w[updated speech],
            author: 'the author is updated'
          }
        end
        run_test!
      end
    end
  end
end
