# frozen_string_literal: true

class CreateSpeech
  include Interactor

  def call
    context.speech = Speech.new(
      user: context.current_user,
      keywords: keywords,
      content: context.content,
      author: context.author,
      speech_date: context.speech_date
    )
    context.speech.save!
  end

  private

  def keywords
    return context.keywords.join(',') if context.keywords.present?
  end
end
