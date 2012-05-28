class IO
  def self.to_array(path)
    value = Array.new
    File.open(path,'r') do |f|
      f.each do |line|
        value << line.to_f
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

  def self.result_to_gnuplot(em_data)
    gamma = em_data.result[:gamma]
    mu = em_data.result[:mu]
    sigma2 = em_data.result[:sigma2]
    round = Proc.new {|n, d| (n * 10 ** d).round / 10.0 ** d}
    print "plot "
    em_data.mix.times do |t|
      if mu[t] >= 0
        print "#{round.call(gamma[t],6)}*exp(-((x-#{round.call(mu[t],6)})**2)/(2.0*sqrt(#{round.call(sigma2[t],6)})*sqrt(#{round.call(sigma2[t],6)})))/(sqrt(2.0*pi)*sqrt(#{round.call(sigma2[t],6)})) + "
      elsif mu[t] < 0
        print "#{round.call(gamma[t],6)}*exp(-((x+#{round.call(mu[t]*-1,6)})**2)/(2.0*sqrt(#{round.call(sigma2[t],6)})*sqrt(#{round.call(sigma2[t],6)})))/(sqrt(2.0*pi)*sqrt(#{round.call(sigma2[t],6)})) + "
      end
    end
    print "\n\n"
    em_data.mix.times do |t|
      if mu[t] >= 0
        print "#{round.call(gamma[t],6)}*exp(-((x-#{round.call(mu[t],6)})**2)/(2.0*sqrt(#{round.call(sigma2[t],6)})*sqrt(#{round.call(sigma2[t],6)})))/(sqrt(2.0*pi)*sqrt(#{round.call(sigma2[t],6)})) w l axis x1y2 lw 3 title '#{round.call(gamma[t],6)}*N(#{round.call(mu[t],6)},#{round.call(sigma2[t],6)})' , "
      elsif mu[t] < 0
        print "#{round.call(gamma[t],6)}*exp(-((x+#{round.call(@mu[t]*-1,6)})**2)/(2.0*sqrt(#{round.call(sigma2[t],6)})*sqrt(#{round.call(sigma2[t],6)})))/(sqrt(2.0*pi)*sqrt(#{round.call(sigma2[t],6)})) w l axis x1y2 lw 3 title '#{round.call(gamma[t],6)}*N(#{round.call(mu[t],6)},#{round.call(sigma2[t],6)})' , "
      end
    end
    print "\n"
  end
  
end
