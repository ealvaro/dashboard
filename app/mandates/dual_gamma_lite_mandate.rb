class DualGammaLiteMandate < Mandate
  def self.valid_attributes
    Mandate.valid_attributes + general_params
  end

  def self.general_params
    %i( running_avg_window logging_period_in_secs )
  end

  def tool_type_klass
    "DualGammaLite"
  end

  def apply_unique_params(params)
  end
end
