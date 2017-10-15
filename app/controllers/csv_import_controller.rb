class CsvImportController < ApplicationController
  DISCREPANCY_DAYS = 15

  def index
  end

  def create
    result = CsvImportService.import(vendor: csv_import_params[:vendor], csv: csv_import_params[:file].tempfile)

    internal_records = InternalRecordImportService.get_request(
      vendor_name: csv_import_params[:vendor],
      start_date:  result[:start_date] - DISCREPANCY_DAYS.days,
      end_date:    result[:start_date] - DISCREPANCY_DAYS.days
    )

    result[:imported_ids].each do |id|
      RecordMatcherService.match(external_record_id: id)
    end

    message = "Imported #{result[:import_count]} records from external CSV<br>and #{internal_records} corresponding records from Negotiatus"

    if !result[:errors]
      flash[:success] = "Success: #{message}"
    else
      flash[:error] = "Found external records with disagreeing values:<br>#{result[:errors].join("<br>")}<br>#{message}"
    end

    redirect_to csv_import_index_path
  end

  private
    def csv_import_params
      params.permit(:vendor, :file)
    end
end