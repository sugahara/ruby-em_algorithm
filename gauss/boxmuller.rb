# -*- coding: utf-8 -*-
##ボックスミュラー法によるガウス分布データ生成
##偶数個しか作れない仕様であることに注意

include Math
def gauss_rand(n,mu,sigma2)
  j=0
  while j < n
    a=rand()
    b=rand()
    r1=sqrt(-2*Math.log(a.to_f)).to_f*sin(2*Math::PI*b.to_f).to_f
    r2=sqrt(-2*Math.log(a.to_f)).to_f*cos(2*Math::PI*b.to_f).to_f
    r3=r1.to_f*Math.sqrt(sigma2).to_f+mu.to_f
    r4=r2.to_f*Math.sqrt(sigma2).to_f+mu.to_f
    print "#{r3}\n"
    print "#{r4}\n"
    j=j+2
  end
end

gauss_rand(7000,5,16.0)
gauss_rand(3000,-5,1.0)
