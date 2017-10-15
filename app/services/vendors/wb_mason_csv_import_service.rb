module Vendors
  class WBMasonCsvImportService
    VENDOR_NAME = "WB Mason"
    HEADERS = {
      invoice_number:              "INVOICE",
      reference_number:            "SALES ORDER",
      negotiatus_reference_number: "PO NUMBER",
      date:                        "INVOICE DATE",
      amount_cents:                "AMOUNT",
      delivery_address_string:     "SHIP TO ADDRESS"
    }

    def self.import(csv:)
      errors        = []
      earliest_date = nil
      latest_date   = nil
      imported      = []

      CSV.read(csv, headers: true).map(&:to_h).each do |row|
        row    = row.map     {|key, value| [key.strip, value] }.to_h
        values = HEADERS.map {|key, value| [key, row[value]]  }.to_h

        values[:date]                     = Date.strptime(values[:date], "%m/%d/%Y")
        values[:amount_cents]             = (values[:amount_cents].gsub(/(\s+\$?)*/, "").to_f * 100).to_i
        values[:delivery_address_string]  = values[:delivery_address_string].gsub(/\s+/, " ") # take out \n
        values[:delivery_address_zipcode] = values[:delivery_address_string].match(/\d{5}/)[0] if values[:delivery_address_string] =~ /\d{5}/
      
        earliest_date, latest_date = get_dates(new_date: values[:date], earliest_date: earliest_date, latest_date: latest_date)
        existing_record = ExternalRecord.find_by(reference_number: values[:reference_number], negotiatus_reference_number: values[:negotiatus_reference_number])

        if !existing_record
          imported << ExternalRecord.create(values.merge(vendor_name: VENDOR_NAME))
        elsif existing_record.amount_cents != values[:amount_cents]
          errors << "#{values[:reference_number]}:#{values[:negotiatus_reference_number]} - existing: #{existing_record.amount_cents / 100.0} new: #{values[:amount_cents] / 100.0}"
        end
      end

      {
        import_count: imported.size,
        imported_ids: imported.map(&:id),
        errors: (errors.present? && errors),
        start_date: earliest_date,
        end_date: latest_date
      }
    end

    private

      def self.get_dates(new_date:, earliest_date:, latest_date:)
        earliest_date = new_date if earliest_date.nil?
        latest_date   = new_date if latest_date.nil?

        [[new_date, earliest_date].min, [new_date, latest_date].max]
      end

  end
end


