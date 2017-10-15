class CsvImportService
  def self.import(vendor:, csv:)
    # if vendor == "WB Mason"
    Vendors::WBMasonCsvImportService.import(csv: csv)
  end
end