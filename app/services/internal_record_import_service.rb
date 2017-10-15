class InternalRecordImportService
  def self.get_request(vendor_name:, start_date:, end_date:)
    response = HTTParty.get(
      "#{ENV['NEGOTIATUS_API_URL']}/invoicebase_internal_records?name=#{vendor_name}&start_date=#{start_date}&end_date=#{end_date}",
      headers: {
        Authorization: "Secret #{ENV['PARTNER_SECRET']}"
      }
    )

    if response.code == 200
      records_imported = 0
      JSON.parse(response.body).with_indifferent_access["order_vendors"].each do |record|
        records_imported += import(vendor: vendor_name, record: record).size
      end

      records_imported
    end
  end

  def self.import(vendor:, record:)
    records = []

    record[:vendor_order_number].each do |vendor_order_number|
      records << InternalRecord.find_or_create_by(
        vendor_name:                 vendor,
        external_reference_number:   vendor_order_number,
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