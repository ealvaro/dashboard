class DualGammaMandateSerializer < BaseMandateSerializer
  attributes :region_name, :settings

  def settings
    result = {}

    # combine :logging_params, :thresholds, :gv_configs with no hierachy
    %i(logging_params thresholds hashed_gv_configs health_params alg_and_qbus_fields gamma_power_settings sif_settings_params sif_bin_params)
    .map { |field| self.send(field)}
    .select(&:present?)
    .flatten
    .inject({}) {|h, fields| h.merge!(fields)}
    .reject{|k,v| v.blank? }
    .each do |k,v|
      result.merge! k => ( v == 'forced_empty' ? "" : v)
    end

    result
  end

  private
  # gv_configs is stored as an array of key value pairs
  def hashed_gv_configs
    return_hash = {}
    Array(object.gv_configs).each_with_index do |hash, index|
      key = hash["key"].gsub(" ","").underscore.dup
      value = hash["value"]
      return_hash["gv#{value}"] = key
    end
    return_hash
  end

  def health_params
    object.health_params
  end

  def logging_params
    object.logging_params
  end
  def thresholds
    object.thresholds
  end

  def alg_and_qbus_fields
    object.alg_and_qbus_fields
  end

  def gamma_power_settings
    object.gamma_power_settings
  end

  def sif_settings_params
    object.sif_settings_params
  end

  def sif_bin_params
    object.sif_bin_params
  end

end
