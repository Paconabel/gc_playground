require 'objspace'

GC.start
GC.disable

def wadus
  objects = []

  ObjectSpace.trace_object_allocations do
    100_000.times do |time|
      objects << 'A' # * 20
      objects << time
      objects << time * 100_000_000
      objects << Rational('1/33')
    end
  end
end

allocated_before = GC.stat(:total_allocated_objects)
freed_before = GC.stat(:total_freed_objects)

wadus

pp ObjectSpace.count_objects

GC.start

allocated_after = GC.stat(:total_allocated_objects)
freed_after = GC.stat(:total_freed_objects)

puts
puts "Total objects allocated: #{allocated_after - allocated_before}"
puts "Total objects freed: #{freed_after - freed_before}"

puts
pp ObjectSpace.count_objects
