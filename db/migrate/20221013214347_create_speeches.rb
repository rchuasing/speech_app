# frozen_string_literal: true

class CreateSpeeches < ActiveRecord::Migration[7.0]
  def change
    create_table :speeches do |t|
      t.belongs_to :user, foreign_key: :user_id
      t.text :content
      t.date :speech_date
      t.text :keywords
      t.timestamps
    end
  end
end
