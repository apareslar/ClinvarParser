file_input = ARGV[0]
target_search = ARGV[1]
target_str = ARGV[2]


def GetColumn(file, colnum)
 arr = []
 i = 0
 file.each do |f1|
  arr[i] = f1.split("\t")[colnum]
  i +=1
 end
 return arr
end

def GetIndex(column, string, exact_match)
  index = []
  i = 0
  column.each do |f2|
  if exact_match  
    if f2 == string
      index << i
    end
  else
    if /#{string}/.match(f2)
        index << i
    end
  end
  i += 1
  end
  return index
end

lines = File.readlines(file_input)
col_num = 0

ex_match = false

if target_search == "VariationID"
  col_num = 0
  ex_match = true
elsif target_search == "Phenotype"
  col_num = 5
elsif target_search == "Gene"
  col_num = 11
  exact_match =true
elsif target_search == "Significance"
  col_num = 1
  exact_match =true
end

col = GetColumn(lines, col_num)

#col.group_by(&:itself).transform_values(&:count)

index = GetIndex(col, target_str, ex_match)

index.each do |ix|
  puts lines[ix]
end