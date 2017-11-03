class Invoice < ActiveRecord::Base
  #include BillableInvoice

  has_many :runs, dependent: :nullify

  validates :status, presence: true, inclusion: { in: :available_statuses }, allow_blank: false
  validates :multiplier_as_billed, numericality: {greater_than: 0}, allow_blank: true
  validates :discount_percent_as_billed, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }, allow_nil: true
  validates :number, presence: true, uniqueness: true, allow_blank: false
  validates :date_of_issue, presence: true, allow_blank: false

  def initialize( *args )
    super
    max_number = Invoice.maximum(:number).to_i
    self.number = max_number >= 1000 ? max_number + 1 : 1000
    self.date_of_issue = Date.today.to_s( :db )
    self.status = "new"
  end

  def job
    runs.count > 0 ? runs[0].job : nil
  end

  def total
    val = read_attribute(:total_in_cents)
    val ? val / 100.0 : 0.0
  end

  def total=(value)
    write_attribute(:total_in_cents, (value.to_f * 100.0))
  end

  def discount
    read_attribute(:discount_in_cents) / 100.0
  end

  def discount=(value)
    write_attribute(:discount_in_cents, (value.to_f * 100.0))
  end

  def mud_types
    ["Oil Based", "Water Based", "Brine"]
  end

  def remove_runs!
    return self unless self.id
    Run.where(invoice_id: self.id).each do |run|
      run.update_attributes invoice_id: nil
    end
    self.reload
  end

  def cleanup_runs
    return true unless runs.count > 0
    for run in runs
      run.update_attributes run.attributes.select{|k,v| k.to_s.include? "_as_billed" }.collect{|k,v| k}.inject({}) {|g,k| g.merge!({k => nil})}
    end
  end

  private

  def available_statuses
    %w(new draft complete)
  end
end
