require "test_helper"

class HistogramTest < ActiveSupport::TestCase
  include Utilities

  test 'factory is valid' do
    assert build(:histogram).valid?
  end

  test 'validates presence of name' do
    assert_not build(:histogram, name: nil).valid?
  end

  test 'validates presence of job' do
    assert_not build(:histogram, job: nil).valid?
  end

  test 'validates presence of run' do
    assert_not build(:histogram, run: nil).valid?
  end

  test 'validates presence of service_number' do
    assert_not build(:histogram, service_number: nil).valid?
  end

  test 'validates presence of data' do
    assert_not build(:histogram, data: nil).valid?
  end
end