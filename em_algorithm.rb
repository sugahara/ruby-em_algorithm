# -*- coding: utf-8 -*-
include Math

DEBUG = 0
STEP = 10000
SOURCE = 1  ## 0=>GMM GEN, 1=>FILE
MODE = 1 ## 0=>VALUE, 1=>DIFFERENTIAL

def sum_array(array)
  sum = 0
  array.each do |v|
    sum += v
  end 
  return sum
end

def gauss(x,mu,sigma2)
  sigma = sqrt(sigma2)
  return exp(-((x-mu)**2)/(2.0*sigma*sigma))/(sqrt(2.0*PI)*sigma)
end

def gauss_gen(mu, sigma2)
  sigma = sqrt(sigma2)
  t = sqrt(-2.0*log(1.0-rand()))
  u = 2.0*PI*rand()
  r1=t*cos(u)
  return r1*sigma+mu
end

def histo_gen(data)
  histo = []
  min = data.min
  max = data.max
  min.upto(max) do |i|
    histo.push [i,data.count(i)]
  end
  return histo
end

def estep() #正解
  K.times do |i|
    @weight[i].clear#後のK.timeの頭につけても良い
  end
  b=Array.new(@observed_data.size,0)
  @observed_data.each_with_index do |v, index|
    #b[index] = @gamma[0] * gauss(v, @mu[0], @sigma2[0]) + @gamma[1] * gauss(v, @mu[1], @sigma2[1])
    b[index] = 0
    K.times do |i|
      b[index] += @gamma[i] * gauss(v, @mu[i], @sigma2[i])
    end
  end

  K.times do |i|#クラスごとの混合係数(weightの添字)
    @observed_data.each_with_index do |v, index|
      w = @gamma[i] * gauss(v, @mu[i], @sigma2[i]) / b[index]
      @weight[i].push(w)
    end
  end
end

def mstep()
  weight_sum = []
  K.times do |i|
    weight_sum[i] = sum_array(@weight[i])
  end

  K.times do |i|
    sum = 0
    @observed_data.each_with_index do |v,index|
      sum += @weight[i][index] * v
    end
    @mu[i] = sum/weight_sum[i]
  end

  #p @mu


  K.times do |i|
    sum = 0
    @observed_data.each_with_index do |v,index|
      sum += @weight[i][index] * (v - @mu[i])**2
    end
    @sigma2[i] = sum / weight_sum[i]
  end

  #p @sigma2

  K.times do |i|
    @gamma[i] = weight_sum[i] / N_NUM
  end
  #p @gamma
end

def log_likelihood()
  sum = 0
  @observed_data.each do |v|
    lh = 0
    K.times do |i|
      lh += @gamma[i] * gauss(v, @mu[i], @sigma2[i])
    end
    # sum += log(@gamma[0] * gauss(v, @mu[0], @sigma2[0]) + @gamma[1] * gauss(v, @mu[1], @sigma2[1]))
    sum += log(lh)
  end
  return sum
end

def max_log_likelihood()
  sum = 0
  @observed_data.each do |v|
    lh = 0
    K.times do |i|
      lh += @gamma_gen[i] * gauss(v, @mu_gen[i], @sigma2_gen[i])
    end
    sum += log(lh)
  end
  return sum
end

#initial_value and GMM GEN definition
if(SOURCE == 0) ## GMM GEN
  @gamma = [0.5, 0.5]
  @mu = [-1, -1]
  @sigma2 = [100, 200]

  ## GMM GEN definition
  @gamma_gen = [0.5,0.5]
  @mu_gen = [50,60]
  @sigma2_gen = [16,16]
  n = [3000, 3000]
  K = @sigma2_gen.size
  n_sum = 0
  n.each do |v|
    n_sum = n_sum + v
  end


elsif(SOURCE == 1) ## FILE
  if(MODE == 0) ## VALUE
    @gamma = [0.2,0.2,0.2,0.1,0.1,0.1,0.1]
    @mu = [0, 10, 20, 30, 40, 50, 100]
    @sigma2 = [500.0, 500.0, 500.0, 500.0, 500.0, 500.0, 500.0]
  elsif(MODE == 1) ## DIFFERENTIAL
    @gamma = [0.2,0.2,0.2,0.1,0.1,0.1,0.1]
    @mu = [-30,30,-10,10,0,-100,100]
    @sigma2 = [500.0, 500.0, 500.0, 500.0, 500.0, 500.0, 500.0]
  end
  K = @mu.size
end

## STORE VAR
@observed_data = []
@weight = []
K.times do |n|
  @weight[n] = Array.new
end
@log_likelihood_history = []

#initial_value_memory
@gamma_i = @gamma
@mu_i = @mu
@sigma2_i = @sigma2

## GMM GEN OR LOAD DATA FROM FILE
if(SOURCE == 0) #FROM GMM GEN
  K.times do |i|
    n[i].times do
      @observed_data.push(gauss_gen(@mu_gen[i], @sigma2_gen[i]))
    end
  end
  
elsif(SOURCE == 1) ## FROM FILE
  File::open(ARGV[0])do|f|
    if(MODE == 0) ## VALUE
      f.each do |line|
        if !line.index("/")
          @observed_data.push(line.chomp.to_i)
        end 
      end
    elsif(MODE == 1) ## DIFFERENTIAL
      prev = nil
      f.each do |line|
        if !line.index("/")
          if prev.nil?
            prev = line.chomp.to_i
          else
            @observed_data.push(line.chomp.to_i - prev)
            prev = line.chomp.to_i
          end
        end
      end
    end
  end

end
N_NUM = @observed_data.size


# histogram output
histo = histo_gen(@observed_data)
if(SOURCE == 0)
  filename = "GMM_GEN"
elsif(SOURCE == 1)
  filename = ARGV[0].split("/").last
end
File.open("histogram/histo_#{filename}.log", 'w') do|f|
  f.puts "# #{Time.now}"
  histo.each do |v|
    f.puts "#{v[0]} #{v[1]}"
  end
end



if(DEBUG==1)
  if(MODE = 0)
    puts "GENERATE VALUE"
    p gamma_gen
    p mu_gen
    p sigma2_gen
  end
  puts "# of mix: #{K}"
  puts "# of data: #{N_NUM}"
end


STEP.times do |i|
  puts "#{i}step(s)"
  @log_likelihood_history.push(log_likelihood())
  puts "log_likelihood: #{@log_likelihood_history.last}"
  p @gamma
  p @mu
  p @sigma2
  puts " "
  
  estep()
  mstep()
  if((log_likelihood() - @log_likelihood_history.last).abs < 0.01)
    break
  end
end

if(SOURCE == 0)
  p max_log_likelihood()
end

if(SOURCE == 0)
  filename = "GMM"
elsif(SOURCE == 1)
  filename = ARGV[0].split("/").last
end
File.open("log_likelihood/#{filename}.log", 'w')do |f|
  @log_likelihood_history.each do |h|
    f.puts h
  end
end

# gnuplot command
round = Proc.new {|n, d| (n * 10 ** d).round / 10.0 ** d}
print "plot "
K.times do |k|
  #print "#{@gamma[k]}*gauss(v, #{@mu[k]}, sqrt(#{@sigma2[k]})) + "
  if @mu[k] >= 0
    print "#{round.call(@gamma[k],6)}*exp(-((x-#{round.call(@mu[k],6)})**2)/(2.0*sqrt(#{round.call(@sigma2[k],6)})*sqrt(#{round.call(@sigma2[k],6)})))/(sqrt(2.0*pi)*sqrt(#{round.call(@sigma2[k],6)})) + "
  elsif @mu[k] < 0
    print "#{round.call(@gamma[k],6)}*exp(-((x+#{round.call(@mu[k]*-1,6)})**2)/(2.0*sqrt(#{round.call(@sigma2[k],6)})*sqrt(#{round.call(@sigma2[k],6)})))/(sqrt(2.0*pi)*sqrt(#{round.call(@sigma2[k],6)})) + "
  end
end
print "\n"
