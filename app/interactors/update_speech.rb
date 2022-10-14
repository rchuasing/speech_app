# frozen_string_literal: true

class UpdateSpeech
  include Interactor

  def call
    context.speech.update!(
      user: context.current_user,
      keywords: keywords,
      content: context.content,
      author: context.author,
      speech_date: context.speech_date
    )
  end

  private

  def keywords
    return context.keywords.join(',') if context.keywords.present?
  end
end
