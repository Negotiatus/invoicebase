class RecordMatcherService
  DISCREPANCY_PERCENTAGE = 0.10

  def self.match(external_record_id:)
    external_record = ExternalRecord.find(external_record_id)

    guess(external_record: external_record)
  end

  private
    def self.guess(external_record:)
      matchers = {
        1.0 => :exact_match,
        0.9 => :match_reference_numbers_and_zip_within_dpc_of_amount,
        0.8 => :match_external_reference_number_within_dpc_of_amount,
        0.5 => :match_external_reference_number
      }

      matchers.keys.sort_by{|conf| -conf}.each do |confidence|
        matches = send(matchers[confidence], external_record: external_record)

        if matches.compact.present?
          matches.each do |internal_record|
            external_record.guesses.create(
              internal_record: internal_record,
              confidence: confidence
            )
          end

          break
        end
      end
    end

    def self.exact_match(external_record:)
      attempted_match = InternalRecord.where(
        vendor_name:                 external_record.vendor_name,
        negotiatus_reference_number: external_record.negotiatus_reference_number,
        external_reference_number:   external_record.reference_number,
        amount_cents:                external_record.amount_cents,
        delivery_address_zipcode:    external_record.delivery_address_zipcode
      ).first

      [attempted_match]
    end

    def self.match_reference_numbers_and_zip_within_dpc_of_amount(external_record:)
      query = InternalRecord.where(
        negotiatus_reference_number: external_record.negotiatus_reference_number,
        external_reference_number:   external_record.reference_number,
        delivery_address_zipcode:    external_record.delivery_address_zipcode,
      )

      query_for_match_within_dpc_of_amount(current_query: query, external_record: external_record)
    end

    def self.match_external_reference_number_within_dpc_of_amount(external_record:)
      query_for_match_within_dpc_of_amount(
        current_query: match_external_reference_number(external_record: external_record),
        external_record: external_record
      )
    end

    def self.match_external_reference_number(external_record:)
      InternalRecord.where(external_reference_number: external_record.reference_number)
    end

    def self.query_for_match_within_dpc_of_amount(current_query:, external_record:)
      current_query.where("? BETWEEN (amount_cents * ?) AND amount_cents", external_record.amount_cents, 1 - DISCREPANCY_PERCENTAGE)
    end
end
