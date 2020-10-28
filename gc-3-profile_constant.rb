require 'ostruct'
GC::Profiler.enable

ACCOUNT = 'CTLN-1234567890-EUR'

def create_transaction
  OpenStruct.new(
    amount: 10,
    account: constant_account,
    entry_type: 'credit'
  )
end

def account
  'CTLN-1234567890-EUR'.tap do |object|
    print "#{object.object_id}\r"
  end
end

def constant_account
  ACCOUNT.tap do |object|
    print "#{object.object_id}\r"
  end
end

def frozen_account
  'CTLN-1234567890-EUR'.freeze.tap do |object|
    print "#{object.object_id}\r"
  end
end

arri = []
500000.times do
arri << create_transaction
end

GC.start


GC::Profiler.report
