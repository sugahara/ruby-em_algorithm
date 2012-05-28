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
end
