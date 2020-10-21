require 'ostruct'
GC::Profiler.enable


# 1000.times do
# Thread.new { puts "hello from thread" }
# end

ACCOUNT = 'CTLN-1234567890-EUR'

def create_transaction(number)
  OpenStruct.new(
    amount: number,
    account: ACCOUNT,
    entry_type: 'credit'
  )
end

# threads = []

# transactions = []
# arri = *(1..100000)
# arri.each do |number|
#   transactions << create_transaction(number)
# end

# threads = []
# 100000.times do |number|
#   threads << Thread.new { create_transaction(number) }
# end
# threads.each(&:join)

threads = []
arri = *(1..100000)
arri.each do |number|
  threads << create_transaction(number)
end
threads.each(&:join)

GC.start

GC::Profiler.report