require 'ostruct'
GC::Profiler.enable

def create_transaction
  OpenStruct.new(
    amount: 10,
    account: 'CTLN-1234567890-EUR',
    entry_type: 'credit'
  )
end

arri = []
10000.times do
  arri << create_transaction
  # transaction = create_transaction
  # arri << transaction
end

GC.start

GC::Profiler.report