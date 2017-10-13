class RecordMatcherService
  DISCREPANCY_DAYS       = 15
  DISCREPANCY_PERCENTAGE = 0.10

  def self.match(external_record_id:)
    external_record = ExternalRecord.find(external_record_id)

    exact_match = find_exact_match(external_record: external_record)

    if exact_match
      if external_record.reconciliation_id.nil?
        external_record.guess.create(
          internal_record: exact_match,
          confidence: 1.0
        )
      end
    else
      make_guesses(external_record: external_record)
    end
  end

  class << self
    private

      def self.find_exact_match(external_record:)
        InternalRecord.where(
          negotiatus_reference_number: external_record.negotiatus_reference_number,
          reference_number:            external_record.reference_number,
          amount_cents:                external_record.amount_cents,
          delivery_address_zipcode:    external_record.delivery_address_zipcode
        ).first
      end

      def self.make_guesses(external_record:)
        # matches reference_number, negotiatus_reference_number & delivery_address_zipcode withing 90% of amount_cents
        guess_ninety_percent_matches(external_record: external_record)
        # matches reference_number
        guess_reference_number(external_record: external_record)
      end

      def self.guess_ninety_percent_matches(external_record:)
        amount_range = [external_record.amount_cents * (1 + DISCREPANCY_PERCENTAGE)..external_record.amount_cents]

        matches = InternalRecord
          .where(
          negotiatus_reference_number: external_record.negotiatus_reference_number,
          reference_number:            external_record.reference_number,
          delivery_address_zipcode:    external_record.delivery_address_zipcode
        )
          .where(amount_cents: amount_range)

        matches.each do |match|
          Guess.find_or_create_by(
            external_record: external_record,
            internal_record: match,
            confidence:      0.9
          )
        end
      end

      def guess_reference_number(external_record:)
        matches = InternalRecord.where(reference_number: external_record.reference_number)

        matches.each do |match|
          Guess.find_or_initialize_by(
            external_record: external_record,
            internal_record: match
          ).update(confidence: 0.5)
        end
      end
  end
end
