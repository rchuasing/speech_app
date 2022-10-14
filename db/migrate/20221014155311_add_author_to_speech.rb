# frozen_string_literal: true

class AddAuthorToSpeech < ActiveRecord::Migration[7.0]
  def change
    add_column :speeches, :author, :string
  end
end
