# -*- coding: utf-8 -*-
class IO
  #ファイルから値を読み込みArrayに挿入
  def self.to_array(path)
    value = Array.new
    File.open(path,'r') do |f|
      f.each do |line|
        value << line.to_f
      end
    end
    value
  end

  #ファイルから値を読み込みその前後差をArrayに挿入
  def self.to_array_diff(path)
    value = Array.new
    value_temp = to_array(path)
    prev = nil
    value = []
    value_temp.each do |val|
      if prev == nil
        prev = val
      else
        value << val - prev
      end
    end
    value
  end
  
  def self.to_stdout
    File.open(path,'r') do |f|
      f.each do |line|
        puts line.to_f
      end
    end
  end

  def self.result_to_gnuplot(result, mix)
    gamma = result[:gamma]
    mu = result[:mu]
    sigma2 = result[:sigma2]
    round = Proc.new {|n, d| (n * 10 ** d).round / 10.0 ** d}
    print "plot "
    mix.times do |t|
      if mu[t] >= 0
        print "#{round.call(gamma[t],6)}*exp(-((x-#{round.call(mu[t],6)})**2)/(2.0*sqrt(#{round.call(sigma2[t],6)})*sqrt(#{round.call(sigma2[t],6)})))/(sqrt(2.0*pi)*sqrt(#{round.call(sigma2[t],6)})) + "
      elsif mu[t] < 0
        print "#{round.call(gamma[t],6)}*exp(-((x+#{round.call(mu[t]*-1,6)})**2)/(2.0*sqrt(#{round.call(sigma2[t],6)})*sqrt(#{round.call(sigma2[t],6)})))/(sqrt(2.0*pi)*sqrt(#{round.call(sigma2[t],6)})) + "
      end
    end
    print "\n\n"
    mix.times do |t|
      if mu[t] >= 0
        print "#{round.call(gamma[t],6)}*exp(-((x-#{round.call(mu[t],6)})**2)/(2.0*sqrt(#{round.call(sigma2[t],6)})*sqrt(#{round.call(sigma2[t],6)})))/(sqrt(2.0*pi)*sqrt(#{round.call(sigma2[t],6)})) w l axis x1y2 lw 3 title '#{round.call(gamma[t],6)}*N(#{round.call(mu[t],6)},#{round.call(sigma2[t],6)})' , "
      elsif mu[t] < 0
        print "#{round.call(gamma[t],6)}*exp(-((x+#{round.call(@mu[t]*-1,6)})**2)/(2.0*sqrt(#{round.call(sigma2[t],6)})*sqrt(#{round.call(sigma2[t],6)})))/(sqrt(2.0*pi)*sqrt(#{round.call(sigma2[t],6)})) w l axis x1y2 lw 3 title '#{round.call(gamma[t],6)}*N(#{round.call(mu[t],6)},#{round.call(sigma2[t],6)})' , "
      end
    end
    print "\n"
  end
  
end
