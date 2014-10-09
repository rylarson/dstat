require 'csv'

module Dstat
  def flatten_headers(csv)
    headers = csv[0]
    csv[0] = []

    good = headers[0]
    headers.each do |header| 
      good = header unless header.nil?
      csv[0] << good
    end

    csv[1] = csv[1].map do |child_header| 
      parent_header = csv[0][csv[1].index(child_header)]
      parent_header != child_header ? "#{parent_header} #{child_header}" : parent_header
    end
    csv[1..-1]
  end

  def normalize_top_level_header(csv)
    headers = csv[0]
    csv[0] = []

    good = headers[0]
    headers.each do |header| 
      good = header unless header.nil?
      csv[0] << good
    end
    csv
  end

  def parse_from_file(file)
  file = File.new(file) unless file.is_a? File
  # Split on the double newlines that separate the dstat header from the csv data
  file = file.read.split("\n\n")
  file = file[1].nil? ? file[0] : file[1]
  CSV.parse(file)
  end

  # 
  # Given a dstat csv file, this will import the data, columnwise, into a Hash.
  # dstat CSV files are often of the form:
  #
  # top_level_header_1,top_level_header_2,,,
  # child_header_1,child_header_2,child_header3,child_header4
  #
  # or a more concrete example:
  #
  # epoch,memory usage,,,
  # epoch,used,buff,cach,free
  # 1121245,12456,12856,20059,2999095
  # 1121246,12457,12855,20068,2996885
  # 
  # Where used, buff, cache, and free all correspond to memory usage. An index is created
  # for each (parent header -> child header), unless parent header == child header.
  #
  # Using the concrete example above, the hash returned from this method would be indexed
  # like so:
  # 
  # hash[:epoch] => [1121245, 1121246]
  # hash[:memory_usage] => {:used => [12456, 12457], 
  #                          :buff => [12856, 12855], 
  #                          :cach => [20059, 20068], 
  #                          :free => [2999095, 2996885]
  #              }
  #
  # Written another way:
  #
  # puts hash[:memory_usage][:used]
  # => "[12456, 12457]"
  #
  # The hash also has aliases for the keys, so you can access the values multiple ways:
  #
  # puts hash[:memory_usage][:used]
  # => "[12456, 12457]"
  #
  # puts hash["memory_usage"]["used"]
  # => "[12456, 12457]"
  #
  # puts hash["memory_usage_used"]
  # => "[12456, 12457]"
  # 
  def import_dstat_csv(file)
    csv = parse_from_file(file)
    csv = normalize_top_level_header(csv)
    csv = csv.transpose
    csv_hash = Hash.new
    csv.each do |column|
      parent_header = column[0].gsub(/\s+/, "_").strip.to_sym
      child_header = column[1].gsub(/\s+/, "_").strip.to_sym
      if (parent_header != child_header)
        csv_hash[parent_header] = Hash.new if csv_hash[parent_header].nil?
        csv_hash[parent_header.to_s] = Hash.new if csv_hash[parent_header.to_s].nil?
        csv_hash[parent_header][child_header] = column[2..-1]
        csv_hash[parent_header.to_s][child_header.to_s] = column[2..-1]
        csv_hash["#{parent_header}_#{child_header}"] = column[2..-1]
      else
        csv_hash[parent_header] = column[2..-1]
        csv_hash[parent_header.to_s] = column[2..-1]
      end
    end
    csv_hash
  end
end