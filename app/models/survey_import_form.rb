class SurveyImportForm
  include ActiveModel::Model

  attr_accessor :job_id, :run_id, :side_track_number
  attr_accessor :order_md, :order_inc, :order_azi, :order_dipa, :order_gx,
                :order_gy, :order_gz, :order_hx, :order_hy, :order_hz
  attr_accessor :pasted_data, :data_file, :col_sep

  def applied_records(run)
    run.surveys.select do |survey|
      data.select{|d| d[:md] == survey.measured_depth_in_feet }
    end
  end

  def created_count(run)
    data.count - applied_records(run).count
  end

  def data
    @data ||= process_data
  end

  private

  def process_data
    file_into_data if data_file.present?
    return if pasted_data.blank?

    lines = []
    
    @col_sep = "\t" if @col_sep == "Tab"
    CSV.parse(pasted_data, col_sep: @col_sep).each do |row|
      lines << process_for_line(row)
    end
    lines
  end

  def file_into_data
    spreadsheet = open_spreadsheet(data_file)
    lines = (1..spreadsheet.last_row).map do |i|
      spreadsheet.row(i).to_a.join(",")
    end
    @pasted_data = lines.join("\r\n")
  end

  def process_for_line(line)
    line_hash = {}
    line.each_with_index do |value, index|
      order = index + 1
      key = hash_of_order.invert[order].to_s.gsub("order_", "")
      value = value
      line_hash[key] = value
    end
    line_hash.with_indifferent_access
  end


  def hash_of_order
    keys = [:order_md, :order_inc, :order_azi, :order_dipa, :order_gx, :order_gy, :order_gz, :order_hx, :order_hy, :order_hz]
    keys.inject({}) do |hash,key|
      hash[key] = self.send(key).to_i
      hash
    end
  end

   def open_spreadsheet(file)
     case File.extname(file.original_filename)
     when ".csv" then Roo::CSV.new(file.path)
     when ".xls" then Roo::Excel.new(file.path, file_warning: :ignore)
     when ".xlsx" then Roo::Excelx.new(file.path, file_warning: :ignore)
     else raise "Unknown file type: #{file.original_filename}"
     end
   end
end
