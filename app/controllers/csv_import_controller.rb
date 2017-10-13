class CsvImportController < ApplicationController
  def index
  end

  def create
    errors = CsvImportService.import(vendor: csv_import_params[:vendor], csv: csv_import_params[:file].tempfile)

    if !errors
      flash[:success] = "Success"
    else
      flash[:error] = "Found external records with disagreeing values:<br>#{errors.join("<br>")}"
    end

    redirect_to csv_import_index_path
  end

  private
    def csv_import_params
      params.permit(:vendor, :file)
    end
end