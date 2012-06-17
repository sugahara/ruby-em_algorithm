require 'gsl'
include Math

def gaussian_rand(mu, sigma2, size)
  sigma = Math::sqrt(sigma2)
  r = GSL::Rng.alloc
  v = r.gaussian(sigma, size)
  v = v.collect {|v| v+mu}
  v.each do |g|
    puts g
  end
end

gaussian_rand(-5, 1, 3000)
gaussian_rand(5, 16, 7000)
