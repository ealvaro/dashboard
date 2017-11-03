unless Rails.env.development?
  exe_path = ENV["WKHTMLTOPDF_PATH"]
else
  exe_path = Rails.root.join('bin', 'wkhtmltopdf-amd64').to_s
end

WickedPdf.config = {
  #:wkhtmltopdf => '/usr/local/bin/wkhtmltopdf',
  #:layout => "pdf.html",
  :exe_path => ENV["WKHTMLTOPDF_PATH"]
}
