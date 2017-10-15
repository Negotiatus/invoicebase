class InternalRecordImporterService
  def self.get_request(vendor_name:, start_date:, end_date:)
    response = HTTParty.get(
      "#{ENV['NEGOTIATUS_API_URL']}/invoicebase_internal_records?name=#{vendor_name}&start_date=#{start_date}&end_date=#{end_date}",
      headers: {
        Authorization: "Secret #{ENV['PARTNER_SECRET']}"
      }
    )

    if response.code == 200
      JSON.parse(response.body)["order_vendors"].each do |record|
        import(record: record)
      end
    end
  end

  def self.import(record:)
    records = []
    
    record[:vendor_order_number].each do |vendor_order_number|
      records << InternalRecord.create(
        reference_number:            vendor_order_number,
        negotiatus_reference_number: record[:negotiatus_order_number],
        delivery_address_string:     record[:address_string],
        delivery_address_zipcode:    record[:address_zip],
        amount_cents:                record[:price_total_cents],
        date:                        record[:order_completed_date]
      )
    end

    records
  end
end