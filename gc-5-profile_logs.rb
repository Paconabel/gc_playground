require 'ostruct'
require 'logger'

GC::Profiler.enable

ACCOUNT = 'CTLN-1234567890-EUR'

def create_transaction
  OpenStruct.new(
    amount: 10,
    account: ACCOUNT,
    entry_type: 'credit'
  )
end

log = Logger.new(STDOUT)

arri = []
100000.times do
log.info('Logging Process Starting')
arri << create_transaction
end

GC.start

GC::Profiler.report