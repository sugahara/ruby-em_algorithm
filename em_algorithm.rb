# -*- coding: utf-8 -*-
class EMAlgorithm
  require './array.rb'
  include Math
  LOOP = 10000
  def initialize(em_data)
    @initial_value = em_data.initial_value
    @mu = @initial_value[:mu]
    @sigma2 = @initial_value[:sigma2]
    @gamma = @initial_value[:gamma]
    @data_array = em_data.data_array
    @mix = @mu.size
    @weight = Array.new(@mix).map! {Array.new()}
  end
  
  def gauss_pdf(x,mu,sigma2)
    sigma = sqrt(sigma2)
    return exp(-((x-mu)**2)/(2.0*sigma*sigma))/(sqrt(2.0*PI)*sigma)
  end
  
  def estep()
    #重みリセット
    @mix.times do |t|
      @weight[t].clear
    end
    temp_new_data = Array.new(@data_array.size, 0)
    @data_array.each_with_index do |val, idx|
      @mix.times do |t|
        temp_new_data[idx] += @gamma[t] * gauss_pdf(val, @mu[t], @sigma2[t])
      end
    end
    
    @mix.times do |t|
      @data_array.each_with_index do |val, idx|
        w = @gamma[t] * gauss_pdf(val, @mu[t], @sigma2[t]) / temp_new_data[idx]
        @weight[t].push(w)
      end
    end
  end
  
  def mstep()
    weight_sum = Array.new
    @mix.times do |t|
      weight_sum[t] = @weight[t].sum
    end
    
    @mix.times do |t|
      sum = (0...@data_array.size).inject(0) do |sum, i|
        sum += @weight[t][i] * @data_array[i]
      end
      @mu[t] = sum/weight_sum[t]
    end
    
    @mix.times do |t|
      sum = (0...@data_array.size).inject(0) do |sum, i|
        sum += @weight[t][i] * (@data_array[i] - @mu[t])**2
      end
      @sigma2[t] = sum / weight_sum[t]
    end

    @mix.times do |t|
      @gamma[t] = weight_sum[t] / @data_array.size
    end
  end
  
  def log_likelihood()
    sum = @data_array.inject(0) do |sum, val|
      lh = (0...@mix).inject(0) do |lh, t|
        lh += @gamma[t] * gauss_pdf(val, @mu[t], @sigma2[t])
      end
      sum += log(lh)
    end
    sum
  end
  
  def run()
    @llh_hist = Array.new
    LOOP.times do |t|
      puts "step#{t}"
      @llh_hist.push(log_likelihood())
      puts "log_likelihood: #{log_likelihood()}"
      p @gamma
      p @mu
      p @sigma2
      puts ""
      estep()
      mstep()
      if((log_likelihood() - @llh_hist.last).abs < 0.01)
        break
      end
    end
    result = {
      :gamma => @gamma,
      :mu => @mu,
      :sigma2 => @sigma2
    }
  end

end
