require "spec_helper"

describe PH do
  file = "spec/image.jpg"
  size = 64

  it "#hash" do
    img = Vips::Image.new_from_file(file)
    width, height = img.width, img.height
    w_scale, v_scale = size.fdiv(width), size.fdiv(height)

    # Rescale to 64x64 and greyscale
    img = img.resize(w_scale, vscale: v_scale).colourspace(:grey16)
    # Ensure a 2D plane
    pixels_2d = img.to_a.map(&:flatten)

    assert_equal "859091ce633aaebb", PH.new(pixels_2d).hash
  end
end
