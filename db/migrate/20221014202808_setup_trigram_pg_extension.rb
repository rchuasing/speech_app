# frozen_string_literal: true

class SetupTrigramPgExtension < ActiveRecord::Migration[7.0]
  def change
    execute 'CREATE EXTENSION pg_trgm;'
  end
end
