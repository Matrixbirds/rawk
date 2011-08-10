require 'set'

module Rawk
  class Program    
    def initialize(input_stream)
      @start, @every, @finish = Set.new, Set.new, Set.new
      @input_stream = input_stream
    end
        
    def start(&block)
      @start << block
    end
    
    def every(&block)
      @every << block
    end
    
    def finish(&block)
      @finish << block
    end
    
    def run(code = "", &block)
      if code.empty?
        instance_eval(&block) 
      else
        instance_eval(code)
      end
      
      @start.each {|b| b.call}
      @input_stream.each_line do |row|
        @every.each {|b| b.call(Line.new(row))}
      end
      @finish.each {|b| b.call}
    end
  end
  
  class Line < String
    def initialize(str)
      super(str.chomp)
    end
    def cols
      split(" ")
    end
  end
end