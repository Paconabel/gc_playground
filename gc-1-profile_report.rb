GC::Profiler.enable

arri = []
10000000.times do
arri << Object.new
end

GC.start

GC::Profiler.report