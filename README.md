# PH
_Perceptual Hashing_

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
