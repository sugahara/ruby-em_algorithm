class Main
  require File.expand_path("../em_data.rb",__FILE__)
  require File.expand_path("../io.rb",__FILE__)
  data_path = ARGV[0]
  data_array = IO::to_array(data_path)
  initial_value = {
    :gamma => [0.2, 0.2, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1],
    :mu =>[20.0, 100.0, 150.0, 250.0, 220.0, 210.0, 190.0, 180.0],
    :sigma2 =>[100000.0, 100000.0, 100000.0, 100000.0, 100000.0, 100000.0, 100000.0, 100000.0]
  }
  initial_value = {
    :gamma => [0.5,0.5],
    :mu => [0.0,10.0],
    :sigma2 => [9.0,9.0]
  }
  em_data = EMData.new(data_array, initial_value)
  p em_data.initial_value
  em = EMAlgorithm.new(em_data)
  result = em.run
  IO::result_to_gnuplot(result, em_data.mix)
end
