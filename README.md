# PH
_Perceptual Hashing_

## What is it?

Perceptual hashing is the technique to generate a fingerprint of an image.

- https://en.wikipedia.org/wiki/Perceptual_hashing
- http://hackerfactor.com/blog/index.php%3F/archives/432-Looks-Like-It.html

## Install

```bash
gem install ph
```

## Usage

`PH` Generates a perceptual hash from an array of pixels.
The way you get that pixel data is up to you. Different techniques can shield different values.
Hashes exist on a similar space but different reads could yield different (subtle) hashes.

### Vips

```ruby
size = 64
img = Vips::Image.new_from_file(file)
width, height = img.width, img.height
w_scale, v_scale = size.fdiv(width), size.fdiv(height)

img = img
  .resize(w_scale, vscale: v_scale)
  .colourspace(:grey16)

pixels_2d = img.to_a.map(&:flatten)

PH.hash(pixels_2d)
# => "859091ce633aaebb"
```

### RMagick

```ruby
img = Magick::ImageList.new(file)
size = 64
img = img
  .scale(size, size)
  .dispatch(0, 0, size, size, "I")
  .each_slice(size)
  .to_a

PH.new(img).vector
# => [1, 0, 0, 0, 0, 1, 0, 1, 1, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 1, 1, 1, 0, 0, 1, 1, 1, 0, 0, 1, 1, 0, 0, 0, 1, 1, 0, 0, 1, 1, 1, 0, 1, 0, 1, 0, 1, 0, 1, 1, 1, 0, 1, 0, 1, 1, 1, 0, 1, 1]
```

### Distance

Since hashes exist on a metric space you can measure how far a hash is from another.
You can use the [hamming gem](https://github.com/elcuervo/hamming) for calculations if needed

```ruby
Hamming.distance(hash_a, hash_b)

# You can also transform hashes based on your storage:
Hamming.vector_to_hash(hash)
Hamming.hash_to_vector(vector)
```

