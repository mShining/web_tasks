#echo Fibonacci sequence-of-number
#150714 by mShining
#new line every 10

@flag=0


while @flag===0
  puts "Please input an integer(1-100): "

  #get N
  @n = gets.to_i

  if (1<=@n and @n<=100)
    @flag=1

    @a = 0
    @b = 1
    @t = 0

    puts
    print "The Fibonacci sequence-of-number(1-"
    print @n
    puts "):"

    #Xun-huan-shu-chu Fibonacci sequence-of-number
    @i = 1
    until ( (@i<=>@n) === 1 )

      #print "i'm here1"

      if (@i === @n)
        print @a
        print "."
        @i = @i + 1
        next
      end

      print @a
      print ","
      @t = @a;
      @a = @b;
      @b = @b + @t;

      #new line every 10
      if @i%10===0
        print "\n"
      end

      @i = @i + 1
    end


  else
    puts "The input is out of range , please input again!"
  end

end
