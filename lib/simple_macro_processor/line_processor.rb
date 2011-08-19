require 'set'

module SimpleMacroProcessor
  class LineProcessor
    attr_reader :variable_holder, :missing_variables, :excercised_variables

    # These could be easily made configurable...
    PATTERN_START = '!<<'
    PATTERN_END = '>>'
    PATTERN = "#{PATTERN_START}(.*?)#{PATTERN_END}"
    PATTERN_REGEXP = Regexp.new(PATTERN)
    
    def initialize(variable_holder)
      @variable_holder = variable_holder
      @missing_variables    = Set.new
      @excercised_variables = Set.new
    end

    def self.variables_in_line(line)
      line.scan(PATTERN_REGEXP).map(&:first).uniq
    end
    
    def interpolate_line(line)
      self.class.variables_in_line(line).each do |variable|
        if !variable_reader.has_key?(variable)
          missing_variables.add(variable)
          next
        end
        excercised_variables.add(variable)
        value = variable_reader.value(variable)
        line.gsub!(/#{PATTERN_START}.*?#{PATTERN_END}/, value)
      end
      line
    end
  end
end
