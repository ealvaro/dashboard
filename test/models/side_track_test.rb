require "test_helper"

class SideTrackTest < ActiveSupport::TestCase
  def test_same_run_number_combination_raises_error
    run = create(:run)
    st = SideTrack.create! number: 1, run: run
    assert_raises ActiveRecord::RecordInvalid do
      st.dup.save!
    end
  end

  def test_number_not_unique_to_entire_side_tracks
    run = create(:run)
    st = SideTrack.create! number: 1, run: run
    assert st.dup.update_attributes run: create(:run)
  end

  def test_run_not_unique_to_entire_side_tracks
    run = create(:run)
    st = SideTrack.create! number: 1, run: run
    assert st.dup.update_attributes number: 2
  end
end
