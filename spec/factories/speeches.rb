# frozen_string_literal: true

FactoryBot.define do
  factory :speech do
    content { 'Sample content' }
    author { 'The Author' }
    speech_date { Time.zone.now }
    keywords { 'key,words' }

    association :user
  end
end
