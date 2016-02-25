require 'csv'

CSV::Converters[:boolean] = lambda do |value|
  case value.to_s
  when 'true' then true
  when 'false' then false
  else value
  end
end

module UploadedCSVMatcher
  def read_uploaded_csv
    path = FakeSFTP.find_path('*.csv')
    contents = path ? FakeSFTP.read(path) : ''

    CSV.parse(contents, headers: true, converters: [:date_time, :boolean],
                        header_converters: :symbol, col_sep: '|')
  end

  def expect_uploaded_csv_to_include(expected)
    rows = read_uploaded_csv
    expect(rows.count).to eq(1), "Expected 1 row, but #{rows.count} rows were found."
    expect(rows.first.to_hash).to include(expected)
  end
end

World(UploadedCSVMatcher)
