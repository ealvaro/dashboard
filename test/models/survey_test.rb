require "test_helper"

class SurveyTest < ActiveSupport::TestCase

  def test_sets_g_total
    survey = Survey.new
    survey.gx = 2.0
    survey.gy = 2.0
    survey.gz = 2.0
    survey.valid?
    expected = Math.sqrt(2**2 + 2**2 + 2**2)
    assert_in_delta expected, survey.g_total, 0.01
  end

  def test_sets_h_total
    survey = Survey.new
    survey.hx = 2.0
    survey.hy = 2.0
    survey.hz = 2.0
    survey.valid?
    expected = Math.sqrt(2**2 + 2**2 + 2**2)
    assert_in_delta expected, survey.h_total, 0.01
  end

  def test_sets_measured_depth_in_feet_from_meters
    survey = Survey.new
    survey.selected_depth_units = "meters"
    survey.measured_depth = 1000
    survey.valid?
    expected = 3280.84
    assert_in_delta expected, survey.measured_depth_in_feet, 0.01
  end

  def test_sets_measured_depth_from_strong
    survey = Survey.new
    survey.selected_depth_units = "meters"
    survey.measured_depth = "1000"
    survey.valid?
    expected = 3280.84
    assert_in_delta expected, survey.measured_depth_in_feet, 0.01
  end

  def test_sets_measured_depth_in_feet_from_feet
    survey = Survey.new
    survey.selected_depth_units = "feet"
    survey.measured_depth = 1000
    survey.valid?
    assert_in_delta 1000, survey.measured_depth_in_feet, 0.01
  end

  def test_generates_key
    survey = Survey.new
    survey.valid?
    assert survey.key.present?
  end

  def test_importing_the_same_survey_data_should_not_make_a_new_survey
    run = create(:run)
    data = { md: 1001, inc: 346, azi: 34, dipa: 123, gx: 1.001, gy: 1.001, gz: 1.001, hx: 1.001, hy: 1.001, hz: 1.001 }
    survey = Survey.create! run: run, measured_depth: data[:md], inclination: data[:inc], azimuth: data[:azi], dip_angle: data[:dipa],
                            gx: data[:gx], gy: data[:gy], gz: data[:gz], hx: data[:hx], hy: data[:hy], hz: data[:hz]
    survey.save!

    Survey.import_for_run run: survey.run, side_track:nil, data: data, import_run: SurveyImportRun.create!, user: nil

    assert_equal 1, Survey.count
  end

  def test_with_verifier_is_accepted
    run = create(:run)
    survey = Survey.new(run: run, measured_depth: 1)
    survey.accepted_by = create(:user)
    survey.save

    assert_equal true, survey.accepted?
    assert_equal false, survey.declined?
  end

  def test_with_decliner_is_declined
    run = create(:run)
    survey = Survey.new(run: run, measured_depth: 1)
    survey.declined_by = create(:user)
    survey.save

    assert_equal true, survey.declined?
  end
end
