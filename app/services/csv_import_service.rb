class CsvImportService
  def self.import(vendor:, csv:)
    # if vendor == "WB Mason"
    Vendors::WBMasonCsvImporter.import(csv: csv)
  end
end