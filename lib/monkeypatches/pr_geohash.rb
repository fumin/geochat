module GeoHash

  # "ezs42" -> "0110111111110000010000010"
  def base32_to_bits base32
    base32.chars.map{ |char|
      n = GeoHash::BASE32.index(char)
      n.to_s(2).rjust(5, "0")
    }.reduce(:+)
  end
  module_function :base32_to_bits

  def base32_to_int base32
    base32_to_bits(base32).to_i(2)
  end
  module_function :base32_to_int

  def encode_to_int lat, lon, precision=8
    base32 = encode(lat, lon, precision)
    base32_to_int base32
  end
  module_function :encode_to_int

  # | geohash length | lat error  | lng error | km error
  # |       1        | +-23       | +-23      | +-2500
  # |       2        | +-2.8      | +-5.6     | +-630
  # |       3        | +-0.7      | +-0.7     | +-78
  # |       4        | +-0.087    | +-0.18    | +-20
  # |       5        | +-0.022    | +-0.022   | +-2.4
  # |       6        | +-0.0027   | +-0.0055  | +-0.61
  # |       7        | +-0.00068  | +-0.00068 | +-0.076
  # |       8        | +-0.000085 | +-0.00017 | +-0.019
  #
  # Inputs  { lat: 25.19, lon: 121.44 , precision: 5 }
  # 1.      The bit array of [25.19, 121.44] with precision of 5 chars is
  #         "1110011000101101011100111"
  # 2.      In 8 chars representation this is
  #         "1110011000101101011100111000000000000000"
  # 3.      Adding and subtracting 1 bit at the 5th precision gives the bounds
  #         "1110011000101101011100110000000000000000" and
  #         "1110011000101101011101000000000000000000"
  #
  # Outputs [988604989440, 988605054976]
  MAX_PRECISION = 8
  def bounds_in_int lat, lon, precision
    i    = encode_to_int lat, lon, MAX_PRECISION
    diff_bits = "1" + "0" * (5*(MAX_PRECISION-precision)) # 5 means 2^5 == 32
    diff = diff_bits.to_i(2)
    [i-diff, i+diff]
  end
  module_function :bounds_in_int

end
