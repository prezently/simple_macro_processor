module SimpleMacroProcessor
  class VariableLineFormatError < StandardError ; end
  
  class VariableHolder
    attr_reader :variable_file, :variable_hash
    def initialize(variable_file)
      # will raise Errno::ENOENT: No such file or director if file does not exist
      @variable_file = variable_file
      @variable_hash = parse_variable_hash
    end

    def re_parse!
      self.variable_hash = parse_variable_hash
    end

    def has_key?(key_name)
      variable_hash.has_key?(key_name)
    end

    def value(key_name)
      variable_hash[key_name]
    end
   
    #--------
    private

    def parse_variable_hash
      hash = {}
      line_number = 0
      variable_file.readlines.each do |line|
        line_number += 1
        next if line =~ /^\s*#/
        # N.B.: It's valid for the value to be an empty string
        line =~ /^(.*?):\s*(.*)\s*?/
        if $1.nil? || $2.nil?
          raise VariableLineFormatError.new("Line #{line_number} is mis-formatted. Format is 'name: value'. " + 
                                            "You provided: #{line}")
        end
        variable_name  = $1.strip
        variable_value = $2.strip
        hash[variable_name] = variable_value
      end
      hash
    end
  end
end
