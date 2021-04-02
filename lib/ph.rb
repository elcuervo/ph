# frozen_string_literal: true
#
class PH
  attr_reader :pixels, :size

  def initialize(pixels_2d, size: 64)
    @pixels = pixels_2d
    @size = size
  end

  def hash
    # Binary to hex string
    vector.join.to_i(2).to_s(16)
  end

  def vector
    @_vector ||= begin
      # Get DCT2D of the pixels
      dct_pixels = dct2d(pixels)
      # Get high frequency corner
      sqrt = Math.sqrt(size).to_i
      coords = Array.new(2, sqrt)
      corner = flat1d(coords, dct_pixels)
      corner_size = corner.length
      # Median values
      med = median(corner)

      result = Array.new(size, 0)

      corner.each.with_index do |f, i|
        # Compare each value to the median
        result[i] = 1 if f > med
      end

      result
    end
  end

  private

  # DCT on a bidimensional plane
  # Thank you matlab forum for explaining that it's just transpositions
  # https://www.mathworks.com/matlabcentral/answers/405088-how-to-implement-dct2-in-matlab-coder
  #
  def dct2d(pixels_2d)
    dct_fn = -> (px) { dct(px) }

    pixels_2d
      .map(&dct_fn).transpose
      .map(&dct_fn).transpose
  end

  # Slices 2D vector into a 1D version
  #
  def flat1d(coords, pixels_2d)
    slice = []
    x, y = coords

    Array.new(x) do |i|
      Array.new(y) do |j|
        slice << pixels_2d[i][j]
      end
    end

    slice
  end

  # Quickselect median.
  # https://rcoh.me/posts/linear-time-median-finding/
  #
  def median(vector)
    return nil if vector.empty?

    n = vector.size

    return quickselect(vector, n / 2) if n.odd?
    0.5 * (quickselect(vector, n / 2 - 1) + quickselect(vector, n / 2))
  end

  def quickselect(vector, pos)
    return vector.first if vector.size == 1 && pos.zero?

    pivot = vector.sample

    lows = vector.select { |i| i < pivot }
    highs = vector.select { |i| i > pivot }
    pivots = vector.select { |i| i == pivot }

    return quickselect(lows, pos) if pos < lows.size
    return pivots.first if pos < pivots.size + lows.size

    quickselect(highs, pos - lows.size - pivots.size)
  end

  # 1984 Lee DCT implementation
  #
  def dct(vector)
    n = vector.size
    return vector if n == 1
    raise StandardError, "Must be nxn" if n.zero? || n.odd?

    half = n / 2
    alpha = []
    beta = []

    Array.new(half).each.with_index do |_, i|
      alpha << (vector[i] + vector[-(i + 1)])
      beta  << (vector[i] - vector[-(i + 1)]) / (Math.cos((i + 0.5) * Math::PI / n) * 2.0)
    end

    alpha = dct(alpha)
    beta = dct(beta)
    result = []

    Array.new(half - 1).each.with_index do |_, i|
      result << alpha[i]
      result << beta[i] + beta[i + 1]
    end

    result << alpha[-1]
    result << beta[-1]

    result
  end
end
