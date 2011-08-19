require 'set'
module SimpleMacroProcessor
  class Checker
    
    def self.get_uninterpolated_variables(file)
      uninterpolated_variables = Set.new
      
      file.readlines.each do |line|
        values = SimpleMacroProcessor::LineProcessor.variables_in_line(line)
        values.each{|v| uninterpolated_variables.add(v) }
      end

      uninterpolated_variables
    end

  end
end
