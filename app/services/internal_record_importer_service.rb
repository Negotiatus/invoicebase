class InternalRecordImporterService
  def self.import(record:)
    internal_record = InternalRecord.create(
      reference_number:            record[:nego_order_number],
      negotiatus_reference_number: record[:vendor_order_number],
      delivery_address_string:     record[:address_string],
      delivery_address_zipcode:    record[:address_zip],
      amount_cents:                record[:total_amount_cents],
      date:                        record[:date]
    )


  end
end
