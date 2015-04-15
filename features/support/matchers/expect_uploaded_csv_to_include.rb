module UploadedCSVMatcher
  def expect_uploaded_csv_to_include(expected)
    rows = read_uploaded_csv
    expect(rows.count).to eq(1), "Expected 1 row, but #{rows.count} rows were found."
    expect(rows.first.to_hash).to include(expected)
  end
end

World(UploadedCSVMatcher)
