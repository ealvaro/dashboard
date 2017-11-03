class ReceiptSerializer < ActiveModel::Serializer
  attributes :mandate_token, :timestamp_utc, :tool_serial

  def timestamp_utc
    object.timestamp_utc.to_i
  end
end
