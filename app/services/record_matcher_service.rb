class RecordMatcherService
  DISCREPANCY_DAYS       = 15
  DISCREPANCY_PERCENTAGE = 0.10

  def self.match(external_record_id:)
    external_record = ExternalRecord.find(external_record_id)

    exact_match = find_exact_match(external_record: external_record)

    if exact_match
      if external_record.reconciliation_id.nil?
        # guess with float of 1
        external_record.update(reconciliation_id: exact_match.id)
      end
    else
      make_guesses(external_record: external_record)
    end
  end

  class << self
    private

      def self.find_exact_match(external_record:)
        # plus zip
        InternalRecord.where(
          reference_number:            external_record.negotiatus_reference_number,
          negotiatus_reference_number: external_record.refernce_number,
          amount_cents:                external_record.amount_cents
        ).first
      end

      def self.make_guesses(external_record:)
        # 90% 3 and 90% match
        # or match external
        # must match external or no match possible
        guess_same_reference_numbers(external_record: external_record)
        guess_similar_amounts_and_zip(external_record: external_record)
      end

      def self.guess_same_reference_numbers(external_record:)
        matches = InternalRecord.where(
          "reference_number = ? OR negotiatus_reference_number = ?",
          external_record.negotiatus_reference_number,
          external_record.reference_number
        )

        matches.each do |match|
          Guess.find_or_create_by(
            external_record: external_record,
            internal_record: match
          )
        end
      end

      def guess_similar_amounts_and_zip(external_record:)
        amount_range = [external_record.amount_cents * (1 + DISCREPANCY_PERCENTAGE)..external_record.amount_cents]
        matches = InternalRecord.where(delivery_address_zipcode: external_record.delivery_address_zipcode)
                                .where(amount_cents: amount_range)

        matches.each do |match|
          Guess.find_or_create_by(
            external_record: external_record,
            internal_record: match
          )
        end
      end
  end
end
