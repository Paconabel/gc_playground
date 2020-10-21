result = GC.stat

p "heap_live_slots: #{result[:heap_live_slots]}"
p "heap_free_slots: #{result[:heap_free_slots]}"
p "total_allocated_objects: #{result[:total_allocated_objects]}"
p "total_freed_objects: #{result[:total_freed_objects]}"
p "malloc_increase_bytes: #{result[:malloc_increase_bytes]}"
p "oldmalloc_increase_bytes: #{result[:oldmalloc_increase_bytes]}"
p "********************"