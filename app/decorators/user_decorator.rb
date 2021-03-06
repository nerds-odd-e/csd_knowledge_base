# frozen_string_literal: true

class UserDecorator < Draper::Decorator
  delegate_all

  def link
    h.link_to name, object
  end
end
