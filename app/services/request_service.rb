class RequestService
  def self.get_request(vendor_name:, start_date:, end_date:)
    response = HTTParty.get(
      "#{ENV['NEGOTIATUS_API_URL']}/invoicebase_domains?vendor_name=#{vendor_name}&start_date=#{start_date}&end_date=#{end_date}",
      headers: {
        Authorization: "Secret #{ENV['PARTNER_SECRET']}"
      }
    )

    if response.code == 200
      response.body["orders"].each do |record|
        InternalRecordImporterService.import(record: record)
      end
    end
  end
end
