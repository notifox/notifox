def progress_meter count
  cents = (1..10).map{|i|
    i*(count/10)
  } + [count]

  ->(n){
    if n == :done
      "100%\n"
    else
      if n > cents.first
        m = cents.shift
        "#{100 * m / count}%\n"
      else
        "."
      end
    end
  }
end
