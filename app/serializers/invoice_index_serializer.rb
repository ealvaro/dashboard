class InvoiceIndexSerializer < InvoiceShallowSerializer
  has_one :job, serialize: JobShallowSerializer
end