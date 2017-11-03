class InvoiceMailer < ActionMailer::Base
  default from: "no_reply@leam.net"

  def invoice(invoice_id, pdf, recipients)
    @invoice = Invoice.find(invoice_id)
    attachments['invoice.pdf'] = pdf if pdf
    for recipient in recipients
      mail(to: recipient, subject: "Lack of a better subject, subject")
    end
  end
end
