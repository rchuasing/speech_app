# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { 'John Doe' }
    email { 'john@email.com' }
    password { 'password4johndoe' }
  end
end
