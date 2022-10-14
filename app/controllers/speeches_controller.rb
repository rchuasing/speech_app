# frozen_string_literal: true

class SpeechesController < ApplicationController
  before_action :authenticate_user!

  def index
    @speeches = Speech.search(search_params[:query]).with_date(search_params[:date_filter])
  end

  def show
    speech
  end

  def create
    result = CreateSpeech.call(speech_params.merge({ current_user: current_user }))
    @speech = result.speech
  end

  def update
    result = UpdateSpeech.call(speech_params.merge({ current_user: current_user, speech: speech }))
    @speech = result.speech
  end

  def destroy
    speech.destroy!
    render json: { status: 'Ok' }, status: :ok
  end

  private

  def speech
    @speech ||= Speech.find(params[:id])
  end

  def speech_params
    params.require(:speech).permit(:content, :speech_date, :author, keywords: [])
  end

  def search_params
    params.permit(:query, :date_filter)
  end
end
