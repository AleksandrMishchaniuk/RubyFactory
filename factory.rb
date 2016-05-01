class Factory
  def self.new(*fields, &methods)
    if fields[0].is_a? String
      name = fields.shift
      const_set(name.capitalize, get_class(*fields, &methods))
    else
      self.get_class(*fields, &methods)
    end
  end

  def self.get_class(*fields, &methods)
    Class.new do
      fields.each { |i| attr_accessor i.to_sym }
      self.class_eval &methods if methods
      
      define_method :initialize do |*args|
        fields.each do |field|
          send(:"#{field}=", args.shift)
        end
      end

      def ==(other)
        compare(other) { |f, s, o| f && (s == o)}
      end

      def eql?(other)
        compare(other) { |f, s, o| f && (s.eql? o)}
      end

      def [](i)
        if i.is_a? Integer
          instance_variable_get(instance_variables[i])
        elsif ( (i.is_a? String) || (i.is_a? Symbol) )
          instance_variable_get(:"@#{i}")
        end
      end

      def []=(i, val)
        if i.is_a? Integer
          instance_variable_set(instance_variables[i], val)
        elsif ( (i.is_a? String) || (i.is_a? Symbol) )
          instance_variable_set(:"@#{i}", val)
        end
      end

      def each(&block)
        instance_variables.each do |var|
          block.call(instance_variable_get(var)) if block
        end
      end

      def each_pair(&block)
        instance_variables.each do |var|
          var1 = var.to_s.delete "@"
          block.call(var1, instance_variable_get(var)) if block
        end
      end

      def hash
        instance_variables.inject(17) do |code, var|
          37*code + instance_variable_get(var).hash
        end
      end

      def length; instance_variables.size; end
      alias size length

      def members
       instance_variables.map { |var| var.to_s.delete('@').to_sym }
      end

      def select(&block)
        instance_variables.inject([]) do |arr, var|
          val = instance_variable_get(var)
          arr.push(val) if block.call(val)
          arr
        end
      end

      def to_a
        instance_variables.map do |var|
          instance_variable_get(var)
        end
      end
      alias values to_a

      def to_h
        instance_variables.inject(Hash.new) do |hash, var|
          hash[var.to_s.delete('@').to_sym] = instance_variable_get(var)
          hash
        end
      end

      def values_at(*args)
        nums = args.inject([]) do |arr, arg|
          if arg.is_a? Integer
            arr << arg
          elsif arg.is_a? Range
            arg.each {|a| arr << a }
          else
            raise 'One of parameters is not Integer or Range'
          end 
          arr           
        end
        nums.map { |num| self[num-1] }
      end

      protected

      def compare(other)
        return true if self.object_id == other.object_id
        self.instance_variables.inject(true) do |f, var|
          return false unless f
          begin
            s = self.instance_variable_get(var)
            o = other.instance_variable_get(var)
            yield(f, s, o) if block_given?
          rescue Exception => e
            puts e.message
            false
          end
        end
      end

    end #end Class.new
  end #end get_class
end