class GetQuarter
def call(year:, quarter:)
  unless quarter > 4
    beginning_of_quarter = beginning_of_quarter(year,quarter)
    end_of_quarter = end_of_quarter(year,quarter)
    info = []
    info << beginning_of_quarter
    info << end_of_quarter
    info << quarterq
    return info
  end
rescue ArgumentError => e
  return 'Enter valid quarter'

end

private
  def beginning_of_quarter(year, quarter)
    Date.new(year, quarter * 3 - 2)
  end

  def end_of_quarter(year, quarter)
    Date.new(year, quarter * 3, -1)
  end
  def month
    10
  end
  def quarter(month)
    case month
    when 1, 2, 3 then "Q1"
    when 4, 5, 6 then "Q2"
    when 7, 8, 9 then "Q3"
    when 10, 11, 12 then "Q4"
    end
  end



end
