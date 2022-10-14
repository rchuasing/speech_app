# frozen_string_literal: true

class RegistrationsController < DeviseTokenAuth::RegistrationsController
  wrap_parameters false
end
