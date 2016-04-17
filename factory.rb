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

      define_method :== do |other|
        self.to_s === other.to_s
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

    end
  end
end