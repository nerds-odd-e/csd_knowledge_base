# frozen_string_literal: true

class CreateWikiService
  def call
    Yaw::WikiSpace.find_or_create_by!(title: 'students')
  end
end
