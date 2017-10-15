class RecordFilter
  attr_reader :filter_start_date,
              :filter_end_date,
              :filter_match_status,
              :filter_payment_status,
              :filter_payable_status

  def initialize(scope:, params: {})
    @scope = scope

    @filter_start_date = params.fetch(:filter_start_date, nil)
    @filter_end_date = params.fetch(:filter_end_date, nil)

    @filter_match_status = params.fetch(:filter_match_status, nil)

    @filter_payment_status = params.fetch(:filter_payment_status, nil)
    @filter_payable_status = params.fetch(:filter_payable_status, nil)
  end

  def records
    @scope = scope_by_start_date if filter_start_date.present?
    @scope = scope_by_end_date if filter_end_date.present?

    @scope = scope_by_match_status if filter_match_status.present?

    @scope = scope_by_payment_status if filter_payment_status.present?
    @scope = scope_by_payable_status if filter_payable_status.present?

    @scope
  end

  private

  def scope_by_start_date
    @scope.where('date >= ?', Date.parse(filter_start_date))
  end

  def scope_by_end_date
    @scope.where('date <= ?', Date.parse(filter_end_date))
  end

  def scope_by_match_status
    case filter_match_status
    when STATUS_UNMATCHED
      @scope.where(reconciliation_id: nil)
    when STATUS_MATCHED
      @scope.where.not(reconciliation_id: nil)
    end
  end

  def scope_by_payment_status
    case filter_payment_status
    when STATUS_UNPAID
      @scope.where(paid_at: nil)
    when STATUS_PAID
      @scope.where.not(paid_at: nil)
    end
  end

  def scope_by_payable_status
    case filter_payable_status
    when STATUS_UNPAYABLE
      @scope.where(payable: false)
    when STATUS_PAYABLE
      @scope.where(payable: true)
    end
  end

  STATUS_UNMATCHED = 'unmatched'.freeze
  STATUS_MATCHED = 'matched'.freeze

  STATUS_UNPAID = 'unpaid'.freeze
  STATUS_PAID = 'paid'.freeze

  STATUS_UNPAYABLE = 'unpayable'.freeze
  STATUS_PAYABLE = 'payable'.freeze
end
