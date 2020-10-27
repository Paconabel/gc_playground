require 'ostruct'

GC::Profiler.enable

class InstanceTransaction
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

class ClassTransaction
  def self.create(account, entry_type)
    OpenStruct.new(
      amount: 10,
      account: account,
      entry_type: entry_type
    )
  end
end

arri = []
500000.times do
  arri << InstanceTransaction.new('credit', 'CTLN-1234567890-EUR').create
  # arri << InstanceTransaction.do('credit', 'CTLN-1234567890-EUR')
  # arri << ClassTransaction.create('credit', 'CTLN-1234567890-EUR')
end

GC.start

GC::Profiler.report
