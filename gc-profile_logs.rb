require 'ostruct'
GC::Profiler.enable

ACCOUNT = 'CTLN-1234567890-EUR'

def create_transaction
  OpenStruct.new(
    amount: 10,
    account: account,
    entry_type: 'credit'
  )
end

def account
  'CTLN-1234567890-EUR'
end

arri = []
100000.times do
p 'vamos a loguear'
arri << create_transaction
p 'hemos logueado'
end

GC.start

GC::Profiler.report