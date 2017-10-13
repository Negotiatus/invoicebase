class InternalRecordImporterService
  def self.get_request(vendor_name:, start_date:, end_date:)
    response = HTTParty.get(
      "#{ENV['NEGOTIATUS_API_URL']}/invoicebase_domains?vendor_name=#{vendor_name}&start_date=#{start_date}&end_date=#{end_date}",
      headers: {
        Authorization: "Secret #{ENV['PARTNER_SECRET']}"
      }
    )

    if response.code == 200
      JSON.parse(response.body)["orders"].each do |record|
        import(record: record)
      end
    end
  end

  def self.import(record:)
    internal_record = InternalRecord.create(
      reference_number:            record[:nego_order_number],
      negotiatus_reference_number: record[:vendor_order_number],
      delivery_address_string:     record[:address_string],
      delivery_address_zipcode:    record[:address_zip],
      amount_cents:                record[:total_amount_cents],
      date:                        record[:date]
    )

    unless internal_record.persisted?
      # need to do anything?
    end
  end
end
