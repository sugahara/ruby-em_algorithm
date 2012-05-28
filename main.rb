class Main
  require './io.rb'
  require './em_data.rb'

  data_path = ARGV[0]
  data_array = IO::to_array(data_path)
  initial_value = {
    :gamma => [0.2, 0.2, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1],
    :mu =>[20.0, 10.0, 15.0, 25.0, 22.0, 21.0, 19.0, 18.0],
    :sigma2 =>[10.0, 10.0, 10.0, 10.0, 10.0, 10.0, 10.0, 10.0]
  }
  em_data = EMData.new(data_array,initial_value)
  em_data.run
end
