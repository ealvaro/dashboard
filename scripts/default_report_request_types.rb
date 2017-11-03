report_types = [{name: "MD", scales: [1, 2, 2.5, 5]},
                {name: "TVD", scales: [1, 2, 2.5, 5]}]

report_types.each do |report_type|
  report_type[:scales].each do |s|
    scaling = "#{s}\":100'"
    unless ReportRequestType.where("name = ? and scaling = ?",
                                   report_type[:name], scaling).present?
      ReportRequestType.create(name:report_type[:name], scaling:scaling)
    end
  end

  # also add any reports without scales
  if report_type[:scales].length == 0
    unless ReportRequestType.find_by_name(report_type[:name]).present?
      ReportRequestType.create(name:report_type[:name])
    end
  end

end
