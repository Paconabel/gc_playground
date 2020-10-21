require 'ostruct'
GC::Profiler.enable

class Transaction

  def self.do(entry_type, account)
    new(entry_type, account).create
  end

  def initialize(entry_type, account)
    @entry_type = entry_type
    @account = account
  end

  def create
    OpenStruct.new(
      amount: 10,
      account: @account,
      entry_type: @entry_type
    )
  end
end

arri = []
1000000.times do
arri << Transaction.new('credit', 'CTLN-1234567890-EUR').create
end

GC.start

GC::Profiler.report