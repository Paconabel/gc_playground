GC::Profiler.enable


# Sin array crea y destruye los objetos conforme necesita el espacio, si lo coleccionamos en una array, no puede reclamarlo
# los valores se incrementan exponencialmente
# como creamos mas valores, nevesitamos  mas tiempo para marcarlos.
arri = []
10000000.times do
arri << Object.new
end

GC.start

GC::Profiler.report