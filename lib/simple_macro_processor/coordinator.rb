module SimpleMacroProcessor

  class Coordinator
    attr_reader( :variable_fd, :variable_file, 
                 :source_fd, :source_file,
                 :destination_fd, :destination_file)
    
    def initialize(variable_fd, source_fd, destination_fd)
      @variable_fd      = variable_fd
      @variable_file    = File.open(variable_fd, "r")
      @source_fd        = source_fd
      @source_file      = File.open(source_fd, "r")
      @destination_fd   = destination_fd
      @destination_file = File.open(destination_fd, "w")
    end
    
    def process
      @num_lines_processed = 0
      source_file.readlines.each do |line|
        @num_lines_processed += 1
        destination_file.puts line_processor.interpolate_line(line)
      end
    end

    def stats
      { :unused_variables => unused_variables,
        :missing_variables => line_processor.missing_variables,
        :num_lines_processed => @num_lines_processed}
    end
    
    #--------
    private
     
    def unused_variables
      variable_holder.variable_hash.keys - line_processor.excercised_variables.to_a
    end

    def variable_holder
      @_variable_holder ||= VariableHolder.new(variable_file)
    end

    def line_processor
      @_line_processor ||= LineProcessor.new(variable_holder)
    end

  end
end
