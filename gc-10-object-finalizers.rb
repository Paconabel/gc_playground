require 'forwardable'
require 'pstore'

# https://stackoverflow.com/questions/12060073/finalizers-in-ruby-is-there-an-equivalent-to-destruct-from-php

# Create a database of people's ages.
People = PStore.new('people.pstore')
People.transaction do
  People['Alice'] = 20
  People['Bob'] = 30
  People['Carl'] = 40
  People['David'] = 50
  People['Eve'] = 60
end

# Shows people in database.  This can show old values if someone
# forgot to update the database!
def show_people(heading)
  People.transaction(true) do
    puts heading
    %w[Alice Bob Carl David Eve].each do |name|
      puts "  #{name} is #{People[name]} years old."
    end
  end
end

show_people("Before birthdays:")

# This is a person in the database.  You can change his or her age,
# but the database is only updated when you call #update or by this
# object's finalizer.
class Person
  # We need a PersonStruct for the finalizer, because Ruby destroys
  # the Person before calling the finalizer.
  PersonStruct = Struct.new(:name, :age, :oage)

  class PersonStruct
    def update(_)
      s = self
      if s.age != s.oage
        People.transaction { People[s.name] = s.oage = s.age }
      end
    end
  end
  private_constant :PersonStruct

  # Delegate name (r) and age (rw) to the PersonStruct.
  extend Forwardable
  def_delegators(:@struct, :name, :age, :age=)

  # Find a person in the database.
  def initialize(name)
    age = People.transaction(true) { People[name] }
    @struct = PersonStruct.new(name, age, age)
    ObjectSpace.define_finalizer(self, @struct.method(:update))
  end

  # Update this person in the database.
  def update
    @struct.update(nil)
  end
end

# Now give everyone some birthdays.
Person.new('Alice').age += 2
Person.new('Bob').age += 1
Person.new('Carl').age += 1
Person.new('David').age += 1
Person.new('Eve').age += 2

# I forgot to keep references to the Person objects and call
# Person#update.  Now I try to run the finalizers.
GC.start

# Did the database get updated?
show_people("After birthdays:")
