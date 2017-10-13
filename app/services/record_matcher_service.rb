class RecordMatcherService
  def self.match(external_record_id:)
    external_record = ExternalRecord.find(external_record_id)

    exact_match = find_exact_match(external_record: external_record)

    if exact_match
      if external_record.reconciliation_id.nil?
        external_record.update(reconciliation_id: exact_match.id)
      end
    else
      make_guesses(external_record: external_record)
    end
  end

  class << self
    private

      def self.find_exact_match(external_record:)
        InternalRecord.where(
          refernce_number:             external_record.negotiatus_reference_number,
          negotiatus_reference_number: external_record.refernce_number,
          amount_cents:                external_record.amount_cents
        ).first
      end
  end
end
