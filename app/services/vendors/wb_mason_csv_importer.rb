module Vendors
  class WBMasonCsvImporter
    HEADERS = {
      invoice_number:              "INVOICE",
      reference_number:            "SALES ORDER",
      negotiatus_reference_number: "PO NUMBER",
      date:                        "INVOICE DATE",
      amount_cents:                "AMOUNT",
      delivery_address_string:     "SHIP TO ADDRESS"
    }

    def self.import(csv:)
      errors = []

      CSV.read(csv, headers: true).map(&:to_h).each do |row|
        row    = row.map     {|key, value| [key.strip, value] }.to_h
        values = HEADERS.map {|key, value| [key, row[value]]  }.to_h
        values[:amount_cents]             = (values[:amount_cents].gsub(/(\s+\$?)*/, "").to_f * 100).to_i
        values[:delivery_address_string]  = values[:delivery_address_string].gsub(/\s+/, " ") # take out \n
        values[:delivery_address_zipcode] = values[:delivery_address_string].match(/\d{5}/)[0] if values[:delivery_address_string] =~ /\d{5}/
      
        existing_record = ExternalRecord.find_by(reference_number: values[:reference_number], negotiatus_reference_number: values[:negotiatus_reference_number])

        if !existing_record
          ExternalRecord.create(values)
        elsif existing_record.amount_cents != values[:amount_cents]
          errors << "#{values[:reference_number]}:#{values[:negotiatus_reference_number]} - existing: #{existing_record.amount_cents / 100.0} new: #{values[:amount_cents] / 100.0}"
        end
      end

      errors.present? && errors
    end
  end
end


