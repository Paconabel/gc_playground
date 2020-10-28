require 'objspace'

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

GC.disable
GC.start

wadus

# Top 10 classes with most objects

ObjectSpace.
  each_object.
  inject(Hash.new(0)) { |h,o| h[o.class] += 1; h }.
  sort_by { |k,v| -v }.
  take(10).
  each { |klass, count| puts "#{count.to_s.ljust(10)} #{klass}" }

puts

# Top strings by size

ObjectSpace.
    each_object(String).
    sort_by { |s| -s.size }.
    take(10).
    each { |s| p s }
