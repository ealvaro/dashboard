class SurveySerializer < ActiveModel::Serializer
  attributes :errors, :show_url
  attributes :id, :version_number, :key, :hidden, :measured_depth_in_feet
  attributes :gx, :gy, :gz, :g_total, :hx, :hy, :hz, :h_total
  attributes :inclination, :azimuth, :dip_angle, :north, :east, :tvd
  attributes :horizontal_section, :dog_leg_severity, :side_track_id
  attributes :start_depth, :accepted_by, :declined_by
  attributes :created_at, :updated_at

  has_one :run
  has_one :user
  has_one :survey_import_run

  def show_url
    object.persisted? ? survey_path( object ) : nil
  end

  def accepted_by
    if object.accepted_by
      object.accepted_by.try(:email)
    end
  end

  def declined_by
    if object.declined_by
      object.declined_by.try(:email)
    end
  end

end
