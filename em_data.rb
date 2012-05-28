# -*- coding: utf-8 -*-
class EMData
  require './em_algorithm.rb'
  attr_accessor :data_array, :initial_value, :result, :mix
  require './array.rb'
  def initialize(data_array, initial_value = {}, mix = 7)
    @data_array = data_array
    @initial_value = initial_value
    if @initial_value[:mu].nil?
      @mix = 7
    else
      @mix = @initial_value[:mu].size      
    end

    ### get random value from data_array for default initial mean value
    if @initial_value[:mu].nil?
      @initial_value[:mu] = (0...@mix).inject([]) do |arr, i|
        arr << @data_array[rand(@data_array.size)]
      end
    end
    
    ### make default gamma value(uniform)
    if @initial_value[:gamma].nil?
      @initial_value[:gamma] = (0...@mix).inject([]) do |arr,i|
        if i < @mix-1
          arr << (1.0/(@mix)).round(2)*100.truncate/100.0 ## truncate x.xx
        else
          arr << (1 - (arr.first*(@mix-1)).round(2)).round(2)
        end
      end
    end
    
    ## make sigma2 value(default:100)
    if @initial_value[:sigma2].nil?
      @initial_value[:sigma2] = (0...@mix).inject([]) do |arr, i|
        arr << 100.0
      end
    end
  end

  def run
    em = EMAlgorithm.new(@data_array, @initial_value)
    @result = em.run()
  end

end
