require 'objspace'

def dump_var(o)
  puts "memsize #{ObjectSpace.memsize_of(o)}"
  puts "sourcefile #{ObjectSpace.allocation_sourcefile(o)}"
  puts "sourceline #{ObjectSpace.allocation_sourceline(o)}"
  puts "GC generation #{ObjectSpace.allocation_generation(o)}"
  puts "class_path #{ObjectSpace.allocation_class_path(o)}"
  puts "method_id #{ObjectSpace.allocation_method_id(o)}"
end

ObjectSpace.trace_object_allocations_start

GC.start
GC.disable

e = 'Ojete Moreno'.freeze
E = 'Oje'.freeze

o = ObjectSpace.each_object(String).find { |x| x == E }

puts "E : #{E.object_id}"
puts "e : #{e.object_id}"
puts "o : #{o.object_id}"


puts
puts

class MyClass
  def initialize
    @wadus = 'tradus'
  end

  def perform
    'wadus'
  end
end

f = MyClass.new
o = ObjectSpace.each_object(MyClass).first

puts "o : #{o.object_id}"
puts "f : #{f.object_id}"

puts

dump_var(f)

puts

dump_var('A' * 100)

File.open('output.txt', 'w') do |f|
  ObjectSpace.dump_all(output: f)
end
