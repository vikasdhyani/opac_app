require 'ostruct'

class HashToObject < OpenStruct
  def initialize(values, *methods_to_support)
    @values = values
    methods_to_support.each do |method|
      eval "def self.#{method}; @values[:#{method}] ; end"
    end
  end
end