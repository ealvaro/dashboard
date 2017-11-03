require "test_helper"

class GammaTest < ActiveSupport::TestCase

  test 'no gamma count changes yield no edits' do
    gamma = create(:gamma)

    assert_equal 0, Gamma.edited.count
  end

  test 'gamma count changes yield edits' do
    gamma = create(:gamma)

    gamma.count = 42
    gamma.save!

    assert_equal 1, Gamma.edited.count
  end

  test 'gamma cannot have same MD for run' do
    gamma = create(:gamma, measured_depth: 1000)

    assert_raises(ActiveRecord::RecordInvalid) do
      create(:gamma, measured_depth: gamma.measured_depth, run: gamma.run)
    end
  end

  test 'gamma cannot have too close MD for run' do
    gamma = create(:gamma, measured_depth: 1000)

    assert_raises(ActiveRecord::RecordInvalid) do
      create(:gamma, measured_depth: gamma.measured_depth + 1e-7,
             run: gamma.run)
    end
  end

  test 'gamma with different enough MD for run creates' do
    gamma = create(:gamma, measured_depth: 1000)

    create(:gamma, measured_depth: gamma.measured_depth + 1e-6,
           run: gamma.run)

    assert_equal 2, Gamma.count
  end

end
