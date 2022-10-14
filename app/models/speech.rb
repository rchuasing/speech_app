# frozen_string_literal: true

class Speech < ApplicationRecord
  include PgSearch::Model
  pg_search_scope :metadata_search,
                  against: %i[content author keywords],
                  using: {
                    trigram: {
                      threshold: 0.1,
                      word_similarity: true
                    }
                  }

  belongs_to :user

  validates :content, presence: true

  scope :with_date, lambda { |date|
    return where('') if date.blank?

    where('speech_date >= ? AND speech_date <= ?', Chronic.parse(date).beginning_of_day, Chronic.parse(date).end_of_day)
  }

  def self.search(search_string)
    if search_string.present?
      metadata_search(search_string)
    else
      where('')
    end
  end
end
