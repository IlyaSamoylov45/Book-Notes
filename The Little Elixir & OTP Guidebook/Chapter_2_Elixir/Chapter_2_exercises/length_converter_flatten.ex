defmodule MeterToLengthConverter.Feet do
  def convert(m) do
    m * 3.2884
  end
end

defmodule MeterToLengthConverter.Inch do
  def convert(m) do
    m * 39.3701
  end
end
