klass = Class.new do
  def initialize(*args)
    @initialized = true
  end

  def initialized?
    @initialized || false
  end
end

puts klass.allocate.initialized?
puts klass.new.initialized?

# class Class
#   def new(*args)
#     obj = allocate
#     obj.initalize(*args)
#     obj
#   end
# end
