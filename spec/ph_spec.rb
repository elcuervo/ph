require "spec_helper"

describe PH do
  let(:file) { "spec/image.jpg" }
  let(:size) { 64 }

  describe "hashing an image" do
    before do
      img = Vips::Image.new_from_file(file)
      width, height = img.width, img.height
      w_scale, v_scale = size.fdiv(width), size.fdiv(height)

      # Rescale to 64x64 and greyscale
      img = img.resize(w_scale, vscale: v_scale).colourspace(:grey16)
      # Ensure a 2D plane
      @pixels_2d = img.to_a.map(&:flatten)
    end

    subject { PH.new(@pixels_2d) }

    it "#hash" do
      assert_equal "859091ce633aaebb", subject.hash
    end

    it "#vector" do
      vector = [
        1, 0, 0, 0, 0, 1, 0, 1, 1, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 1, 1, 1, 0, 0, 1, 1, 1,
        0, 0, 1, 1, 0, 0, 0, 1, 1, 0, 0, 1, 1, 1, 0, 1, 0, 1, 0, 1, 0, 1, 1, 1, 0, 1, 0, 1, 1, 1, 0,
        1, 1
      ]

      assert_equal vector, subject.vector
    end
  end

  describe "comparing hashes" do
    let(:hash_a) { "859091ce633aaebb" }
    let(:hash_b) { "859091ce633aaeba" }

    let(:vector_a) do
      [
        1, 0, 0, 0, 0, 1, 0, 1, 1, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 1, 1, 1, 0, 0, 1, 1, 1,
        0, 0, 1, 1, 0, 0, 0, 1, 1, 0, 0, 1, 1, 1, 0, 1, 0, 1, 0, 1, 0, 1, 1, 1, 0, 1, 0, 1, 1, 1, 0,
        1, 1
      ]
    end

    let(:vector_b) do
      [
        1, 0, 0, 0, 0, 1, 0, 1, 1, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 1, 1, 1, 0, 0, 1, 1, 1,
        0, 0, 1, 1, 0, 0, 0, 1, 1, 0, 0, 1, 1, 1, 0, 1, 0, 1, 0, 1, 0, 1, 1, 1, 0, 1, 0, 1, 1, 1, 0,
        1, 0
      ]
    end

    it "conversion" do
      assert_equal vector_a, PH.hash_to_vector(hash_a)
      assert_equal hash_b, PH.vector_to_hash(vector_b)
    end

    it "#distance" do
      assert_equal 0, PH.distance(vector_b, vector_b)
      assert_equal 0, PH.distance(hash_a, hash_a)
      assert_equal 1, PH.distance(hash_a, vector_b)
    end
  end
end
