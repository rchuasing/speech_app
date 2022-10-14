# frozen_string_literal: true

require 'rails_helper'
require 'swagger_helper'

RSpec.describe 'Authentication API', type: :request do
  path '/auth/sign_in' do
    post 'Signs in user' do
      security [Authorization: []]
      tags 'Authentication'
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

      response '200', 'user signed in' do
        let(:user) { create(:user) }
        let(:email) { user.email }
        let(:password) { 'password4johndoe' }

        let(:params) { { email: email, password: password } }

        run_test! do |response|
          expect(response.headers['access-token']).not_to be_empty
          expect(response.headers['Authorization']).not_to be_empty
          expect(response.headers['token-type']).to eq('Bearer')
          expect(response.headers['uid']).to eq(user.email)
        end
      end

      response '401', 'invalid sign in' do
        let(:user) { create(:user) }
        let(:email) { user.email }
        let(:password) { 'asdf' }
        let(:params) { { email: email, password: password } }

        run_test!
      end
    end
  end

  path '/auth/sign_out' do
    delete 'Signs out user' do
      security [Authorization: []]
      tags 'Authentication'
      consumes 'application/json'
      produces 'application/json'
      parameter name: 'access-token', in: :header, type: :string, nullable: true
      parameter name: 'Authorization', in: :header, type: :string, nullable: true

      response '200', 'user signed in' do
        let!(:current_user) { create(:user, email: 'john2@email.com') }
        let!(:login_credentials) { do_login }
        let(:Authorization) { login_credentials['Authorization'] }
        let(:'access-token') { login_credentials['access-token'] }
        run_test! do |_response|
          expect(JSON.parse(response.body)['success']).to eq(true)
        end
      end

      response '404', 'user is not signed in' do
        let(:Authorization) { '' }
        let(:'access-token') { '' }
        run_test!
      end
    end
  end
end
