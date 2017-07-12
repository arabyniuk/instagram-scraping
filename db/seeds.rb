require 'csv'

CSV.foreach("hotels.csv", headers: :first_row, col_sep: "\t", external_encoding: "SHIFT_JIS", internal_encoding: "utf-8", quote_char: "|") do |row|
  next unless row[0]
  Hotel.create(id: row[0], name_japanese: row[1], name: row[2], former_name_japanese: row[3], former_name: row[4], rooms_count: row[5], address: row[6], latitude: row[7], longitude: row[8] )
end
