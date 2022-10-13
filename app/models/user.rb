# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable
  # :jwt_authenticable,
  # :registerable,
  # jwt_revocation_strategy: JwtDenylist
end
