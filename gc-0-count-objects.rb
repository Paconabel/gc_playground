def display_count
  data = ObjectSpace.count_objects

  puts "Total: #{data[:TOTAL]} Free: #{data[:FREE]} Object: #{data[:T_OBJECT]}"
end

arri = []
500.times do
  object = Object.new
  # arri << object
  display_count
end

GC.start
p '***************'
display_count