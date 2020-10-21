require 'ostruct'
GC::Profiler.enable

ACCOUNT = 'CTLN-1234567890-EUR'

def create_transaction
  OpenStruct.new(
    amount: 10,
    account: ACCOUNT,
    entry_type: 'credit'
  )
end

def report
  result = GC.stat
  p "heap_live_slots: #{result[:heap_live_slots]}"
  p "heap_free_slots: #{result[:heap_free_slots]}"
  p "total_allocated_objects: #{result[:total_allocated_objects]}"
  p "total_freed_objects: #{result[:total_freed_objects]}"
  p "malloc_increase_bytes: #{result[:malloc_increase_bytes]}"
  p "oldmalloc_increase_bytes: #{result[:oldmalloc_increase_bytes]}"
  p "********************"
end

100.times do
  arri.each do |n|
    report
    obj = create_transaction
    arri << obj
  end
end


# GC.start

# GC::Profiler.report


# GC.start
# before = GC.stat(:total_freed_objects)

# RETAINED = []
# 100_000.times do
#   RETAINED << 'create_transaction'
# end

# GC.start
# after = GC.stat(:total_freed_objects)
# puts "Objects Freed: #{after - before}"