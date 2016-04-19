class Factory
  def self.new(*fields, &methods)
    if fields[0].is_a? String
      name = fields.shift
      eval "#{name.capitalize} = self.get_class(*fields, &methods)"
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
          instance_variable_set("@#{field}".to_sym, args.shift)
        end
      end

      define_method :to_s do
        vals = instance_variables.map { |var| instance_variable_get(var) }
        vals * ', '
      end
      alias_method :inspect, :to_s

      define_method :== do |other|
        return true if self.object_id == other.object_id
        self.instance_variables.inject(true) do |f, var|
          return false unless f
          begin
            s = self.instance_variable_get(var)
            o = other.instance_variable_get(var)
            f && (s == o)
          rescue Exception => e
            puts e.message
            false
          end
        end
      end

      define_method :eql? do |other|
        return true if self.object_id == other.object_id
        self.instance_variables.inject(true) do |f, var|
          return false unless f
          begin
            s = self.instance_variable_get(var)
            o = other.instance_variable_get(var)
            f && (s.eql? o)
          rescue  Exception => e
            puts e.message
            false
          end
        end
      end

      define_method :[] do |i|
        if i.is_a? Integer
          instance_variable_get(instance_variables[i])
        elsif ( (i.is_a? String) || (i.is_a? Symbol) )
          instance_variable_get("@#{i}".to_sym)
        end
      end

      define_method :[]= do |i, val|
        if i.is_a? Integer
          instance_variable_set(instance_variables[i], val)
        elsif ( (i.is_a? String) || (i.is_a? Symbol) )
          instance_variable_set("@#{i}".to_sym, val)
        end
      end

      define_method :each do |&block|
        instance_variables.each do |var|
          block.call(instance_variable_get(var)) if block
        end
      end

      define_method :each_pair do |&block|
        instance_variables.each do |var|
          var1 = var.to_s.delete "@"
          block.call(var1, instance_variable_get(var)) if block
        end
      end

      define_method :hash do
        instance_variables.inject(17) do |code, var|
          37*code + instance_variable_get(var).hash
        end
      end

      define_method :length do; instance_variables.size; end
      alias_method :size, :length

      define_method :members do
       instance_variables.map { |var| var.to_s.delete('@').to_sym }
      end

      define_method :select do |&block|
        instance_variables.inject([]) do |arr, var|
          val = instance_variable_get(var)
          arr.push(val) if block.call(val)
          arr
        end
      end

      define_method :to_a do
        instance_variables.map do |var|
          instance_variable_get(var)
        end
      end
      alias_method :values, :to_a

      define_method :to_h do
        instance_variables.inject(Hash.new) do |hash, var|
          hash[var.to_s.delete('@').to_sym] = instance_variable_get(var)
          hash
        end
      end

      define_method :values_at do |*args|
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

    end
  end
end