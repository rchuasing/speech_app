# frozen_string_literal: true

require 'rails_helper'
require 'swagger_helper'

RSpec.describe 'Registration API', type: :request do
  path '/auth' do
    post 'Register a user' do
      tags 'Registration'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :params, in: :body, schema: {
        type: :object,
        required: %w[email password],
        properties: {
          email: {
            type: :string
          },
          password: {
            type: :string
          }
        }
      }

      response '200', 'user registered' do
        let(:email) { 'testing123@sample.com' }
        let(:password) { 'password4johndoe' }

        let(:params) { { email:, password: } }

        run_test! do |response|
          expect(response.headers['access-token']).not_to be_empty
          expect(response.headers['Authorization']).not_to be_empty
          expect(response.headers['token-type']).to eq('Bearer')
          expect(response.headers['uid']).to eq(email)
        end
      end

      response '422', 'invalid registration' do
        let(:user) { create(:user) }
        let(:email) { user.email }
        let(:password) { 'xs4johndoe' }
        let(:params) { { email:, password: } }

        run_test!
      end
    end
  end
end
