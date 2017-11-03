class AddHealthParamsToMandates < ActiveRecord::Migration
  def change
  add_column  :mandates, :differential_diversion_threshold, :float
  add_column  :mandates, :differential_diversion_threshold_high, :float
  add_column  :mandates, :high_or_low_threshold_percentage, :integer
  add_column  :mandates, :high_timeout, :integer
  add_column  :mandates, :low_timeout, :integer
  add_column  :mandates, :requalification_timeout, :integer
  add_column  :mandates, :diversion_crossing_threshold, :integer
  add_column  :mandates, :diversion_integration_period, :integer
  add_column  :mandates, :diversion_window, :integer
  add_column  :mandates, :kstd, :float
  add_column  :mandates, :kskew, :float
  add_column  :mandates, :kkurt, :float

  end
end
