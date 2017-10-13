class RecordsController < ApplicationController
  def index
    @external_records = RecordFilter.new(
      scope: ExternalRecord.all,
      params: params.permit(
        :filter_start_date,
        :filter_end_date
      )
    ).records
  end

  private

  def filter_by_date

  end

  def filter_by_match_status

  end

  def filter_by_paid_status

  end
end
