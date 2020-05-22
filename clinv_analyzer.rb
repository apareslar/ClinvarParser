require 'optparse'

############################################################################################
## METHODS
############################################################################################
def load_file(file)
  records = []
  File.open(file).each do |line|
    line.chomp!
    fields = line.split("\t")
    records << fields 
  end
 return records
end

def extract_records(records, col_num, keyword, full_match)
  selected_records = []
  records.each do |record|
    search_field = record[col_num]
    if full_match && search_field == keyword
        selected_records << record
    elsif !full_match && search_field.include?(keyword)
        selected_records << record
    end
  end
  # selected_records = records.select do |record|
  #   search_field = record[col_num]
  #   full_match && search_field == keyword ||!full_match && search_field.include?(keyword)
  # end
  return selected_records
end

############################################################################################
## OPTPARSE
############################################################################################
options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: "File.basename(__FILE__)" [options]"

  options[:input] = nil
  opts.on("-i", "--input PATH", "Path to input file") do |item|
    options[:input] = item
  end

  options[:target_search] = 'phenotype'
  opts.on("-t", "--target_search STRING", "Field in which to perform the search. Tags are 'variation_id', 'phenotype', 'gene', 'significance'. Default 'phenotype' ") do |item|
    options[:input] = item
  end

  options[:keyword] = nil
  opts.on("-k", "--keyword STRING", "String to use in the search") do |item|
    options[:keyword] = item
  end
end.parse!

############################################################################################
## MAIN
############################################################################################
records = load_file(options[:input])


full_match = true

col_num = nil
if options[:target_search] == "variation_id"
  col_num = 0
elsif options[:target_search] == "phenotype"
  col_num = 5
  full_match = false
elsif options[:target_search] == "gene"
  col_num = 11
elsif options[:target_search] == "significance"
  col_num = 1
end

records = extract_records(records, col_num, options[:keyword], full_match)

