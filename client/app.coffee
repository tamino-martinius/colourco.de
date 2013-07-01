converter =
  bounds:
    hex:
      r: {min: 0, max: 1, f: 255}       # r ∊ [0, 1]    red
      g: {min: 0, max: 1, f: 255}       # g ∊ [0, 1]    green
      b: {min: 0, max: 1, f: 255}       # b ∊ [0, 1]    blue
    rgb:
      r: {min: 0, max: 1, f: 255}       # r ∊ [0, 1]    red
      g: {min: 0, max: 1, f: 255}       # g ∊ [0, 1]    green
      b: {min: 0, max: 1, f: 255}       # b ∊ [0, 1]    blue
    hsl:
      h: {min: 0, max: 1, f: 360}       # h ∊ [0, 1[    hue
      s: {min: 0, max: 1, f: 100}       # s ∊ [0, 1]    saturation
      l: {min: 0, max: 1, f: 100}       # l ∊ [0, 1]    lightness
    hsv:
      h: {min: 0, max: 1, f: 360}       # h ∊ [0, 1[    hue
      s: {min: 0, max: 1, f: 100}       # s ∊ [0, 1]    saturation
      v: {min: 0, max: 1, f: 100}       # v ∊ [0, 1]    value
    cmy:
      c: {min: 0, max: 1, f: 100}       # c ∊ [0, 1[    cyan
      m: {min: 0, max: 1, f: 100}       # m ∊ [0, 1]    magenta
      y: {min: 0, max: 1, f: 100}       # y ∊ [0, 1]    yellow
    cmyk:
      c: {min: 0, max: 1, f: 100}       # c ∊ [0, 1[    cyan
      m: {min: 0, max: 1, f: 100}       # m ∊ [0, 1]    magenta
      y: {min: 0, max: 1, f: 100}       # y ∊ [0, 1]    yellow
      k: {min: 0, max: 1, f: 100}       # k ∊ [0, 1]    key
    XYZ:
      X: {min: 0, max: 0.95047, f: 100} # X ∊ [0, 0.95047]
      Y: {min: 0, max: 1.00000, f: 100} # Y ∊ [0, 1.00000]
      Z: {min: 0, max: 1.08883, f: 100} # Z ∊ [0, 1.08883]
    Yxy:
      Y: {min: 0, max: 1, f: 100}       # Y ∊ [0, 1]
      x: {min: 0, max: 1, f: 100}       # x ∊ [0, 1]
      y: {min: 0, max: 1, f: 100}       # y ∊ [0, 1]
    lab:
      l: {min:  0, max: 1, f: 100}      # l ∊ [0, 1]
      a: {min: -1, max: 1, f: 100}      # a ∊ [-1, 1]
      b: {min: -1, max: 1, f: 100}      # b ∊ [-1, 1]
    validate: (type, values, factorize = false) ->
      result = {}
      for key, b of converter.bounds[type]
        if factorize is on
          result[key] = Math.max(b.min * b.f, Math.min(b.max * b.f, ~~(values[key] * b.f)))
        else
          result[key] = Math.max(b.min, Math.min(b.max, values[key]))
      result

  # ----------------------------------- #
  # -- base functions: * -> rgb -> * -- #
  # ----------------------------------- #
  base:

    # ----------------- #
    # -- rgb <-> rgb -- #
    # ----------------- #
    #rgb -> rgb
    "rgb-to-rgb": (values) -> converter.bounds.validate "rgb", values # validate

    # ----------------- #
    # -- hex <-> rgb -- #
    # ----------------- #
    #hex -> rgb
    "hex-to-rgb": (values) -> converter.bounds.validate "rgb", values # validate

    #rgb -> hex
    "rgb-to-hex": (values) -> converter.bounds.validate "rgb", values # validate

    # ----------------- #
    # -- rgb --> fgc -- #
    # ----------------- #
    #rgb -> fgc
    "rgb-to-fgc": (values) ->
      #fgc is a fore-ground-color matching to rgb
      # validate input
      # logic
      rgb = converter.bounds.validate "rgb", values # validate
      m = 96 / 255
      m *= -1 if Math.max(rgb.r, rgb.g, rgb.b) > 1 - m
      # validate output
      converter.bounds.validate "rgb", {r: rgb.r + m, g: rgb.g + m, b: rgb.b + m}

    # ----------------- #
    # -- hsl <-> rgb -- #
    # ----------------- #
    #hsl -> rgb
    "hsl-to-rgb": (values) -> # see: http://en.wikipedia.org/wiki/HSV_color_space
      # validate input
      values.h = values.h % 1
      hsl = converter.bounds.validate "hsl", values
      # logic
      H = hsl.h * 6.0                           # H ∊ [0, 6[    hue * 6
      C = (1 - Math.abs(2 * hsl.l - 1)) * hsl.s # C ∊ [0, 1]    chroma
      X = C * (1 - Math.abs(H % 2 - 1))         # X ∊ [0, 1]    intermediate
      r = g = b = 0
      r = C if (0 <= H < 1) or (5 <= H < 6)
      r = X if (1 <= H < 2) or (4 <= H < 5)
      g = C if (1 <= H < 3)
      g = X if (0 <= H < 1) or (3 <= H < 4)
      b = C if (3 <= H < 5)
      b = X if (2 <= H < 3) or (5 <= H < 6)
      m = hsl.l - 0.5 * C # match lightness
      # validate output
      converter.bounds.validate "rgb", {r: r + m, g: g + m, b: b + m}

    #rgb -> hsl
    "rgb-to-hsl": (values) -> # see: http://easyrgb.com/index.php?X=MATH&H=18#text18
      # validate input
      rgb = converter.bounds.validate "rgb", values
      # logic
      a = Math.min(rgb.r, rgb.g, rgb.b) # a ∊ [0, 1]    min value
      z = Math.max(rgb.r, rgb.g, rgb.b) # z ∊ [0, 1]    max value
      d = (z - a)                       # d ∊ [0, 1]    delta value
      l = (z + a) / 2                   # l ∊ [0, 1]    lightness
      h = s = 0
      if d > 0 # color isn't gray
        s = d / if l < 0.5 then z + a else 2 - z - a # saturation
        d2 = d / 2 # delta half
        dr = (((z - rgb.r) / 6) + d2) / d # delta red
        dg = (((z - rgb.g) / 6) + d2) / d # delta green
        db = (((z - rgb.b) / 6) + d2) / d # delta blue
        if      rgb.r is z then h = (0 / 3) + db - dg
        else if rgb.g is z then h = (1 / 3) + dr - db
        else if rgb.b is z then h = (2 / 3) + dg - dr
        h += 1 if h < 0
        h -= 1 if h >= 1
      # validate output
      converter.bounds.validate "hsl", {h: h, s: s, l: l}

    # ----------------- #
    # -- hsv <-> rgb -- #
    # ----------------- #
    #hsv -> rgb
    "hsv-to-rgb": (values) -> # see: http://www.easyrgb.com/index.php?X=MATH&H=21#text21
      # validate input
      values.h = values.h % 1
      hsv = converter.bounds.validate "hsv", values
      # logic
      r = g = b = hsv.v
      if hsv.s > 0
        H = hsv.h * 6
        vi = ~~H
        v1 = hsv.v * (1 - hsv.s)
        v2 = hsv.v * (1 - hsv.s * (H - vi))
        v3 = hsv.v * (1 - hsv.s * (1 - (H - vi)))

        r = hsv.v if (0 <= H < 1) or (5 <= H < 6)
        r = v1    if (2 <= H < 4)
        r = v2    if (1 <= H < 2)
        r = v3    if (4 <= H < 5)
        g = hsv.v if (1 <= H < 3)
        g = v1    if (4 <= H < 6)
        g = v2    if (3 <= H < 4)
        g = v3    if (0 <= H < 1)
        b = hsv.v if (3 <= H < 5)
        b = v1    if (0 <= H < 2)
        b = v2    if (5 <= H < 6)
        b = v3    if (2 <= H < 3)
      # validate output
      converter.bounds.validate "rgb", {r: r, g: g, b: b}

    #rgb -> hsv
    "rgb-to-hsv": (values) -> # see: http://www.easyrgb.com/index.php?X=MATH&H=20#text20
      # validate input
      rgb = converter.bounds.validate "rgb", values
      # logic
      a = Math.min(rgb.r, rgb.g, rgb.b) # a ∊ [0, 1]    min value
      z = Math.max(rgb.r, rgb.g, rgb.b) # z ∊ [0, 1]    max value
      d = (z - a)                       # d ∊ [0, 1]    delta value

      v = z
      h = s = 0
      if d > 0 # color isn't gray
        s = d / z # saturation
        d2 = d / 2 # delta half
        dr = (((z - rgb.r) / 6) + d2) / d # delta red
        dg = (((z - rgb.g) / 6) + d2) / d # delta green
        db = (((z - rgb.b) / 6) + d2) / d # delta blue
        if      rgb.r is z then h = (0 / 3) + db - dg
        else if rgb.g is z then h = (1 / 3) + dr - db
        else if rgb.b is z then h = (2 / 3) + dg - dr
        h += 1 if h < 0
        h -= 1 if h >= 1
      # validate output
      converter.bounds.validate "hsv", {h: h, s: s, v: v}

    # ----------------- #
    # -- cmy <-> rgb -- #
    # ----------------- #
    #cmy -> rgb
    "cmy-to-rgb": (values) -> # see: http://www.easyrgb.com/index.php?X=MATH&H=12#text12
      # validate input
      cmy = converter.bounds.validate "cmy", values
      # logic
      r = 1 - cmy.c
      g = 1 - cmy.m
      b = 1 - cmy.y
      # validate output
      converter.bounds.validate "rgb", {r: r, g: g, b: b}

    #rgb -> cmy
    "rgb-to-cmy": (values) -> # see: http://www.easyrgb.com/index.php?X=MATH&H=11#text11
      # validate input
      rgb = converter.bounds.validate "rgb", values
      # logic
      y = 1 - rgb.r
      m = 1 - rgb.g
      c = 1 - rgb.b
      # validate output
      converter.bounds.validate "cmy", {c: c, m: m, y: y}

    # ------------------ #
    # -- cmyk <-> rgb -- #
    # ------------------ #
    #cmyk -> rgb
    "cmyk-to-rgb": (values) -> # see: http://www.easyrgb.com/index.php?X=MATH&H=21#text21
      # validate input
      cmyk = converter.bounds.validate "cmyk", values
      # logic
      c = (cmyk.c * (1 - cmyk.k) + cmyk.k)
      m = (cmyk.m * (1 - cmyk.k) + cmyk.k)
      y = (cmyk.y * (1 - cmyk.k) + cmyk.k)
      # validate output
      converter.base["cmy-to-rgb"] {c: c, m: m, y: y}

    #rgb -> cmyk
    "rgb-to-cmyk": (values) -> # see: http://www.easyrgb.com/index.php?X=MATH&H=13#text13
      # validate input
      cmy = converter.base["rgb-to-cmy"] values
      # logic
      k = Math.min(1, cmy.c, cmy.m, cmy.y)

      c = 0 if k is 1 # black
      m = 0 if k is 1 # black
      y = 0 if k is 1 # black

      c = (cmy.c - k) / (1 - k) if k > 0
      m = (cmy.m - k) / (1 - k) if k > 0
      y = (cmy.y - k) / (1 - k) if k > 0
      # validate output
      converter.bounds.validate "cmyk", {c: c, m: m, y: y, k: k}

    # ----------------- #
    # -- XYZ <-> rgb -- #
    # ----------------- #
    #XYZ -> rgb
    "XYZ-to-rgb": (values) -> # see: http://www.easyrgb.com/index.php?X=MATH&H=14#text14
      XYZ = converter.bounds.validate "XYZ", values
      # logic
      r = XYZ.X *  3.2406 + XYZ.Y * -1.5372 + XYZ.Z * -0.4986
      g = XYZ.X * -0.9689 + XYZ.Y *  1.8758 + XYZ.Z *  0.0415
      b = XYZ.X *  0.0557 + XYZ.Y * -0.2040 + XYZ.Z *  1.0570

      r = if r > 0.0031308 then 1.055 * ( r ^ ( 1 / 2.4 ) ) - 0.055 else 12.92 * r
      g = if g > 0.0031308 then 1.055 * ( g ^ ( 1 / 2.4 ) ) - 0.055 else 12.92 * g
      b = if b > 0.0031308 then 1.055 * ( b ^ ( 1 / 2.4 ) ) - 0.055 else 12.92 * b
      # validate output
      converter.bounds.validate "rgb", {r: r, g: g, b: b}

    #rgb -> XYZ
    "rgb-to-XYZ": (values) -> # see: http://easyrgb.com/index.php?X=MATH&H=02#text2
      # validate input
      rgb = converter.bounds.validate "rgb", values
      # logic
      r = if rgb.r > 0.04045 then ((rgb.r + 0.055) / 1.055) ^ 2.4 else rgb.r / 12.92
      g = if rgb.g > 0.04045 then ((rgb.g + 0.055) / 1.055) ^ 2.4 else rgb.g / 12.92
      b = if rgb.b > 0.04045 then ((rgb.b + 0.055) / 1.055) ^ 2.4 else rgb.b / 12.92

      X = rgb.r * 0.4124 + rgb.g * 0.3576 + rgb.b * 0.1805
      Y = rgb.r * 0.2126 + rgb.g * 0.7152 + rgb.b * 0.0722
      Z = rgb.r * 0.0193 + rgb.g * 0.1192 + rgb.b * 0.9505
      # validate output
      converter.bounds.validate "XYZ", {X: X, Y: Y, Z: Z}

    # ----------------- #
    # -- Yxy <-> rgb -- #
    # ----------------- #
    #Yxy -> rgb
    "Yxy-to-rgb": (values) -> # see: http://easyrgb.com/index.php?X=MATH&H=04#text4
      # validate input
      Yxy = converter.bounds.validate "Yxy", values
      # logic
      X = Yxy.x * ( Yxy.Y / Yxy.y )
      Y = Yxy.Y
      Z = ( 1 - Yxy.x - Yxy.y ) * ( Yxy.Y / Yxy.y )
      # validate output
      converter.base["XYZ-to-rgb"] {X: X, Y: Y, Z: Z}

    #rgb -> Yxy
    "rgb-to-Yxy": (values) -> # see: http://easyrgb.com/index.php?X=MATH&H=03#text3
      # validate input
      rgb = converter.bounds.validate "rgb", values
      # logic
      XYZ = converter.base["rgb-to-XYZ"] rgb
      x = y = 1
      if not (XYZ.X is XYZ.Y is XYZ.Z is 0)
        x = XYZ.X / ( XYZ.X + XYZ.Y + XYZ.Z )
        y = XYZ.Y / ( XYZ.X + XYZ.Y + XYZ.Z )
      # validate output
      converter.bounds.validate "Yxy", {Y: XYZ.Y, x: x, y: y}

    # ----------------- #
    # -- lab <-> rgb -- #
    # ----------------- #
    #lab -> rgb
    "lab-to-rgb": (values) -> # see: http://easyrgb.com/index.php?X=MATH&H=08#text8
      # validate input
      lab = converter.bounds.validate "lab", values
      # logic
      Y = (lab.l + 16 ) / 116
      X = lab.a / 500 + Y
      Z = Y - lab.b / 200

      X = if X^3 > 0.008856 then X^3 else ( X - 16 / 116 ) / 7.787
      Z = if Z^3 > 0.008856 then Z^3 else ( Z - 16 / 116 ) / 7.787
      Y = if Y^3 > 0.008856 then Y^3 else ( Y - 16 / 116 ) / 7.787

      X *= converter.bounds.XYZ.X
      Y *= converter.bounds.XYZ.Y
      Z *= converter.bounds.XYZ.Z
      # validate output
      converter.base["XYZ-to-rgb"] {X: X, Y: Y, Z: Z}

    #rgb -> lab
    "rgb-to-lab": (values) -> # see: http://www.easyrgb.com/index.php?X=MATH&H=07#text7
      # validate input
      rgb = converter.bounds.validate "rgb", values
      # logic
      XYZ = converter.base["rgb-to-XYZ"] values
      X = XYZ.X / converter.bounds.XYZ.X
      Y = XYZ.Y / converter.bounds.XYZ.Y
      Z = XYZ.Z / converter.bounds.XYZ.Z

      X = if X > 0.008856 then X ^ ( 1 / 3 ) else ( 7.787 * X ) + ( 16 / 116 )
      Y = if Y > 0.008856 then Y ^ ( 1 / 3 ) else ( 7.787 * Y ) + ( 16 / 116 )
      Z = if Z > 0.008856 then Z ^ ( 1 / 3 ) else ( 7.787 * Z ) + ( 16 / 116 )

      l = ( 116 * Y ) - 16
      a = 500 * ( X - Y )
      b = 200 * ( Y - Z )
      # validate output
      converter.bounds.validate "lab", {l: l, a: a, b: b}

  stringlify:
    tags: (tag, str) ->
      ot = ct = ""
      ot = "<#{tag}>" if tag? and tag.length > 0
      ct = "</#{tag}>" if tag? and tag.length > 0
      str.replace(/\[/g, ot).replace(/\]/g, ct)
    rgb: (values, tag = null) ->
      rgb = converter.bounds.validate "rgb", values, true
      converter.stringlify.tags tag, """
        rgb([#{rgb.r}], [#{rgb.g}], [#{rgb.b}])
      """
    hex: (values, tag = null) ->
      hex = converter.bounds.validate "rgb", values, true
      r = hex.r.toString(16)
      g = hex.g.toString(16)
      b = hex.b.toString(16)
      r = "0#{r}" if hex.r < 16
      g = "0#{g}" if hex.g < 16
      b = "0#{b}" if hex.b < 16
      converter.stringlify.tags tag, """
        #[#{r}][#{g}][#{b}]
      """
    fgc: (values, tag = null) ->
      fgc = converter.bounds.validate "rgb", values, true
      converter.stringlify.tags tag, """
        rgb([#{fgc.r}], [#{fgc.g}], [#{fgc.b}])
      """
    hsl: (values, tag = null) ->
      hsl = converter.bounds.validate "hsl", values, true
      converter.stringlify.tags tag, """
        hsl([#{hsl.h}], [#{hsl.s}]%, [#{hsl.l}]%)
      """
    hsv: (values, tag = null) ->
      hsv = converter.bounds.validate "hsv", values, true
      converter.stringlify.tags tag, """
        hsv([#{hsv.h}], [#{hsv.s}]%, [#{hsv.v}]%)
      """
    cmy: (values, tag = null) ->
      cmy = converter.bounds.validate "cmy", values, true
      converter.stringlify.tags tag, """
        cmy([#{cmy.c}], [#{cmy.m}], [#{cmy.y}])
      """
    cmyk: (values, tag = null) ->
      cmyk = converter.bounds.validate "cmyk", values, true
      converter.stringlify.tags tag, """
        cmyk([#{cmyk.c}], [#{cmyk.m}], [#{cmyk.y}], [#{cmyk.k}])
      """
    XYZ: (values, tag = null) ->
      XYZ = converter.bounds.validate "XYZ", values, true
      converter.stringlify.tags tag, """
        XYZ([#{XYZ.X}], [#{XYZ.Y}], [#{XYZ.Z}])
      """
    Yxy: (values, tag = null) ->
      Yxy = converter.bounds.validate "Yxy", values, true
      converter.stringlify.tags tag, """
        Yxy([#{Yxy.Y}]%, [#{Yxy.x}]%, [#{Yxy.y}]%)
      """
    lab:(values, tag = null) ->
      lab = converter.bounds.validate "lab", values, true
      converter.stringlify.tags tag, """
        lab([#{lab.l}], [#{lab.a}], [#{lab.b}])
      """

  scheme:
    "monochrome":
      [
        {
          ratio: 1
          h: 
            "mode": "global" # changes hue on all swatches on edit
            origin: (value, seed) -> value
          s:
            "mode": "single" # changes value per swatch
            origin: (value, seed) -> value + seed * 0.1
          l:
            "mode": "uniform" # changes spread on all sawtches on edit
            origin: (value, seed) -> value + seed
        }
      ]
    "monochrome-dark":
      [
        {
          ratio: 0.4
          h: 
            "mode": "fixed" # unable to change
            origin: (value, seed) -> 0
          s:
            "mode": "fixed" # unable to change
            origin: (value, seed) -> 0
          l:
            "mode": "uniform" # changes spread on all sawtches on edit
            origin: (value, seed) -> value + seed
        }
        {
          ratio: 0.6
          h: 
            "mode": "global" # changes hue on all swatches on edit
            origin: (value, seed) -> value
          s:
            "mode": "single" # changes value per swatch
            origin: (value, seed) -> value + seed * 0.1
          l:
            "mode": "uniform" # changes spread on all sawtches on edit
            origin: (value, seed) -> value + seed
        }
      ]
    "monochrome-light":
      [
        {
          ratio: 0.6
          h: 
            "mode": "global" # changes hue on all swatches on edit
            origin: (value, seed) -> value
          s:
            "mode": "single" # changes value per swatch
            origin: (value, seed) -> value + seed * 0.1
          l:
            "mode": "uniform" # changes spread on all sawtches on edit
            origin: (value, seed) -> value + seed
        }
        {
          ratio: 0.4
          h: 
            "mode": "fixed" # unable to change
            origin: (value, seed) -> 0
          s:
            "mode": "fixed" # unable to change
            origin: (value, seed) -> 0
          l:
            "mode": "uniform" # changes spread on all sawtches on edit
            origin: (value, seed) -> value + seed
        }
      ]
    "analogic":
      [
        {
          ratio: 1
          h: 
            "mode": "uniform" # changes spread on all sawtches on edit
            origin: (value, seed) -> value + seed * 0.5
          s:
            "mode": "global" # changes hue on all swatches on edit
            origin: (value, seed) -> value + seed * 0.1
          l:
            "mode": "uniform" # changes spread on all sawtches on edit
            origin: (value, seed) -> value + seed * 0.1
        }
      ]
    "complement":
      [
        {
          ratio: 0.4
          h: 
            "mode": "global" # changes hue on all swatches on edit
            origin: (value, seed) -> value + 0.5
          s:
            "mode": "single" # changes value per swatch
            origin: (value, seed) -> value + seed * 0.25
          l:
            "mode": "uniform" # changes spread on all sawtches on edit
            origin: (value, seed) -> value + seed * 0.25
        }
        {
          ratio: 0.6
          h: 
            "mode": "global" # changes hue on all swatches on edit
            origin: (value, seed) -> value
          s:
            "mode": "single" # changes value per swatch
            origin: (value, seed) -> value + seed * 0.25
          l:
            "mode": "uniform" # changes spread on all sawtches on edit
            origin: (value, seed) -> value + seed * 0.25
        }
      ]
    "analogic-complement":
      [
        {
          ratio: 0.4
          h: 
            "mode": "global" # changes hue on all swatches on edit
            origin: (value, seed) -> value + 0.5
          s:
            "mode": "single" # changes value per swatch
            origin: (value, seed) -> value + seed * 0.5
          l:
            "mode": "uniform" # changes spread on all sawtches on edit
            origin: (value, seed) -> value + seed * 0.5
        }
        {
          ratio: 0.6
          h: 
            "mode": "uniform" # changes spread on all sawtches on edit
            origin: (value, seed) -> value + seed * 0.75
          s:
            "mode": "single" # changes value per swatch
            origin: (value, seed) -> value + seed * 0.1
          l:
            "mode": "global" # changes hue on all swatches on edit
            origin: (value, seed) -> value + seed * 0.1
        }
      ]
    "triad":
      [
        {
          ratio: 0.25
          h: 
            "mode": "global" # changes hue on all swatches on edit
            origin: (value, seed) -> value + 0.33
          s:
            "mode": "single" # changes value per swatch
            origin: (value, seed) -> value + seed * 0.25
          l:
            "mode": "uniform" # changes spread on all sawtches on edit
            origin: (value, seed) -> value + seed * 0.25
        }
        {
          ratio: 0.25
          h: 
            "mode": "global" # changes hue on all swatches on edit
            origin: (value, seed) -> value - 0.33
          s:
            "mode": "single" # changes value per swatch
            origin: (value, seed) -> value + seed * 0.25
          l:
            "mode": "uniform" # changes spread on all sawtches on edit
            origin: (value, seed) -> value + seed * 0.25
        }
        {
          ratio: 0.5
          h: 
            "mode": "global" # changes hue on all swatches on edit
            origin: (value, seed) -> value
          s:
            "mode": "single" # changes value per swatch
            origin: (value, seed) -> value + seed * 0.25
          l:
            "mode": "uniform" # changes spread on all sawtches on edit
            origin: (value, seed) -> value + seed * 0.25
        }
      ]
    "quad":
      [
        {
          ratio: 0.20
          h: 
            "mode": "global" # changes hue on all swatches on edit
            origin: (value, seed) -> value + 0.25
          s:
            "mode": "single" # changes value per swatch
            origin: (value, seed) -> value + seed * 0.25
          l:
            "mode": "uniform" # changes spread on all sawtches on edit
            origin: (value, seed) -> value + seed * 0.25
        }
        {
          ratio: 0.20
          h: 
            "mode": "global" # changes hue on all swatches on edit
            origin: (value, seed) -> value + 0.5
          s:
            "mode": "single" # changes value per swatch
            origin: (value, seed) -> value + seed * 0.25
          l:
            "mode": "uniform" # changes spread on all sawtches on edit
            origin: (value, seed) -> value + seed * 0.25
        }
        {
          ratio: 0.20
          h: 
            "mode": "global" # changes hue on all swatches on edit
            origin: (value, seed) -> value - 0.25
          s:
            "mode": "single" # changes value per swatch
            origin: (value, seed) -> value + seed * 0.25
          l:
            "mode": "uniform" # changes spread on all sawtches on edit
            origin: (value, seed) -> value + seed * 0.25
        }
        {
          ratio: 0.40
          h: 
            "mode": "global" # changes hue on all swatches on edit
            origin: (value, seed) -> value
          s:
            "mode": "single" # changes value per swatch
            origin: (value, seed) -> value + seed * 0.25
          l:
            "mode": "uniform" # changes spread on all sawtches on edit
            origin: (value, seed) -> value + seed * 0.25
        }
      ]
    "generate": (mode) ->
      colors = Session.get "colors"
      color = Session.get "currentColor"
      scheme = converter.scheme[mode]
      ratios = []
      counts = []
      for group, groupIndex in scheme
        ratios.push group.ratio
        counts.push 0
      colorWeight = 1 / colors.length
      for clr, colorIndex in colors
        maxRatio = -1
        maxRatioIndex = -1
        for ratio, ratioIndex in ratios
          if ratio > maxRatio
            maxRatio = ratio
            maxRatioIndex = ratioIndex
        ratios[maxRatioIndex] -= colorWeight
        counts[maxRatioIndex] += 1
      seed = 0.5
      seedStep = seed / colors.length
      hSeed = 0
      sMaxSeed = Math.min(1, color.s + seed / 2)
      sMinSeed = Math.max(0, sMaxSeed - seed)
      sSeed = sMinSeed - color.s
      lMaxSeed = Math.min(1, color.l + seed / 2)
      lMinSeed = Math.max(0, lMaxSeed - seed)
      lSeed = lMinSeed - color.l
      colorIndex = 0
      for group, groupIndex in scheme
        for colorCount in [1..counts[groupIndex]]
          h = group.h.origin color.h, hSeed
          h += 1 if h < 0
          h -= 1 if h > 1
          hSeed += seedStep
          s = group.s.origin color.s, sSeed
          sSeed += seedStep
          l = group.l.origin color.l, lSeed
          lSeed += seedStep
          hsl = converter.bounds.validate "hsl", {h: h, s: s, l: l}
          colors[colorIndex] = hsl
          colorIndex += 1
      Session.set "colors", colors

  convert: (srcType, targetType, values) ->
    converter.base["rgb-to-#{targetType}"](converter.base["#{srcType}-to-rgb"](values))

Session.setDefault "colors", []
Session.setDefault "currentColor", {h: 0, s: 0.5, l: 0.5}
Session.setDefault "currentMenu", "menu-none"
Session.setDefault "schemeMode", "none"
Session.setDefault "editActive", true
Session.setDefault "displayColorType", "hex"
Session.setDefault "liftedColorIndex", null

Handlebars.registerHelper "foreach", (arr, options) ->
  return _.map arr, (item, index) ->
    item.$key   = index
    item.$index = index
    item.$first = index is 0
    item.$last  = index is arr.length-1
    return options.fn(item)
  .join('')
Template.menu["menu-class"] = (name) -> if Session.equals("currentMenu", name) then "active" else ""

Template.menu.rendered = () ->
  $(".menu [data-page]").click () ->
    $this = $ @
    pageIndex = $this.attr("data-page") * 1
    pageName = $this.attr("data-page-name")
    if pageIndex is 1
      Session.set "liftedColorIndex", null
      Session.set "schemeMode", pageName.replace("menu-","")
      if Session.equals "schemeMode", "none"
        Session.set "colors", []
        Session.set "editActive", true
      else
        Session.set "editActive", true
        Session.set "colors", [
          {h:  0, s: 0.5, l: 0.3}
          {h: .1, s: 0.5, l: 0.3}
          {h: .2, s: 0.5, l: 0.3}
          {h: .3, s: 0.5, l: 0.3}
          {h: .4, s: 0.5, l: 0.3}
        ]
        converter.scheme.generate Session.get("schemeMode")
    Session.set "currentMenu", pageName
    window.nextPage pageIndex
    return

Template.scheme.preserve [
  ".preview"
  ".details"
]

Template.scheme.colors = () -> Session.get "colors"
Template.scheme.currentColor = () -> Session.get "currentColor"
Template.scheme.editActive = () -> Session.get "editActive"
Template.scheme.isLifted = (index) -> Session.equals "liftedColorIndex", index
Template.scheme.isSchemeMode = () -> result = not Session.equals "schemeMode", "none"
Template.scheme.isCenter = (index) -> Math.floor(Session.get("colors").length / 2) is index
Template.scheme.bounds = () -> converter.bounds[Session.get "displayColorType"]
Template.scheme.factorizedColorValue = (hsl, key) ->
  type = Session.get("displayColorType")
  ~~(converter.convert("hsl", type, hsl)[key] * converter.bounds[type][key].f)
Template.scheme.displayColorType = (type) -> Session.get "displayColorType"
Template.scheme.getColor = (hsl, type) ->
  new Handlebars.SafeString converter.stringlify[type](converter.convert("hsl", type, hsl))
Template.scheme.getColorTag = (hsl, type) ->
  new Handlebars.SafeString converter.stringlify[type](converter.convert("hsl", type, hsl),"b")
Template.scheme.colorBack = (hsl) -> converter.stringlify.rgb(converter.convert("hsl", "rgb", hsl))
Template.scheme.markerLeft = (hsl) -> "#{hsl.h * 100}%"
Template.scheme.markerTop  = (hsl) -> "#{hsl.l * 100}%"
Template.scheme.colorFore = (hsl) -> converter.stringlify.fgc(converter.convert("hsl", "fgc", hsl))
Template.scheme.linkLess = (hsl) ->
  hex = converter.stringlify.hex(converter.convert("hsl", "hex", hsl)).substr(1)
  "http://api.colourco.de/export/less/%23#{hex}"
Template.scheme.linkImage = (hsl) ->
  hex = converter.stringlify.hex(converter.convert("hsl", "hex", hsl)).substr(1)
  "http://api.colourco.de/export/png/%23#{hex}"
Template.scheme.linkPerma = (hsl) ->
  hex = converter.stringlify.hex(converter.convert("hsl", "hex", hsl)).substr(1)
  "/none/%23#{hex}"
Template.scheme.editColor = (type, hsl) ->
  color = converter.convert "hsl", type, hsl
  inputs = ""
  cssClass = "edit-color"
  cssClass += " active" if Session.equals "displayColorType", type
  if type is "hex"
    value = converter.stringlify.hex(color).substr 1
    inputs += """
      <input
        type="text"
        data-type="#{type}"
        value="#{value}"
      />
    """
  else
    for key, bound of converter.bounds[type]
      value = ~~(color[key] * bound.f)
      inputs += """
        <input
          type="text"
          data-type="#{type}"
          data-key="#{key}"
          value="#{value}"
        />
      """
  new Handlebars.SafeString """
    <div class="#{cssClass}">
      <div class="hint--left" data-hint="click to choose '#{type}' as standard representation">
        <span data-type="#{type}">#{type}</span>
      </div>
      #{inputs}
    </div>
  """
Template.scheme.colorSlider = () ->
  type = Session.get "displayColorType"
  hsl = Session.get "currentColor"
  if not Template.scheme.isSchemeMode()
    hsl = Session.get("colors")[Session.get("liftedColorIndex")]

  color = converter.convert "hsl", type, hsl
  rows = ""
  for key, bound of converter.bounds[type]
    value = ~~(color[key] * bound.f)
    min = bound.min * bound.f
    max = bound.max * bound.f
    valueTag = ""
    valueTag = "value=\"#{value}\""
    gradientSteps = 10
    gradientRange = bound.max - bound.min
    gradientStep = gradientRange / gradientSteps
    gradientBody = ""
    for stepIndex in [0..gradientSteps]
      percentage = (100 / gradientSteps) * stepIndex
      gradientValue = bound.min + gradientStep * stepIndex
      gradientColor = jQuery.extend {}, color
      gradientColor[key] = gradientValue
      rgb = converter.stringlify.rgb(converter.convert type, "rgb", gradientColor)
      gradientBody += ", #{rgb} #{percentage.toFixed(2)}%"
    gradient = ""
    gradient += "background:-webkit-linear-gradient(left    #{gradientBody});"
    gradient += "background:   -moz-linear-gradient(left    #{gradientBody});"
    gradient += "background:    -ms-linear-gradient(left    #{gradientBody});"
    gradient += "background:     -o-linear-gradient(left    #{gradientBody});"
    gradient += "background:        linear-gradient(to right#{gradientBody});"
    console.log color
    console.log gradient
    rows += """
      <tr>
        <td>
          #{key}
        </td>
        <td style="#{gradient}">
          <input
            type="range"
            min="#{min}"
            max="#{max}"
            data-key="#{key}"
            step="any"
            #{valueTag} />
        </td>
        <td>
          #{value}
        </td>
      </tr>
    """
  new Handlebars.SafeString """
    <table>
      <colgroup>
        <col width="2em" />
        <col width="*" />
        <col width="4em" />
      </colgroup>
      <tbody>
        #{rows}
      </tbody>
    </table>
  """




Template.scheme.events
  "mousemove .edit": (e) ->
    color = Session.get "currentColor"
    $swatch = $(e.srcElement or e.target)
    while not $swatch.hasClass "swatch"
      $swatch = $swatch.parent()
    offset = $swatch.offset()
    h = (e.pageX - offset.left) / ~~($swatch.width() * 0.99)
    l = (e.pageY - offset.top) / $swatch.height()
    hsl = {h: h, s: color.s, l: l}
    Session.set "currentColor", hsl
  "mousemove .edit-scheme": (e) ->
    color = Session.get "currentColor"
    $swatches = $(e.srcElement or e.target)
    while not $swatches.hasClass "swatches"
      $swatches = $swatches.parent()
    offset = $swatches.offset()
    h = (e.pageX - offset.left - $swatches.width() * 0.05) / ~~($swatches.width() * 0.9)
    l = (e.pageY - offset.top) / $swatches.height()
    hsl = {h: h, s: color.s, l: l}
    Session.set "currentColor", hsl
    converter.scheme.generate Session.get("schemeMode")
  "click .edit": (e) ->
    colors = Session.get "colors"
    colors.push Session.get "currentColor"
    Session.set "colors", colors
    Session.set "editActive", false
    Session.set "liftedColorIndex", null
  "click .edit-scheme": (e) ->
    Session.set "editActive", false
    Session.set "liftedColorIndex", null
  "click .icon-lock": (e) ->
    Session.set "editActive", true
    Session.set "liftedColorIndex", null
  "click .add": (e) ->
    Session.set "editActive", true
    Session.set "liftedColorIndex", null
  "click .add-scheme": (e) ->
    e.preventDefault()
    colors = Session.get "colors"
    colors.push Session.get "currentColor"
    Session.set "colors", colors
    Session.set "liftedColorIndex", null
    converter.scheme.generate Session.get("schemeMode")
    return false
  "click .remove-scheme": (e) ->
    e.preventDefault()
    colors = Session.get "colors"
    colors.pop()
    Session.set "colors", colors
    Session.set "liftedColorIndex", null
    converter.scheme.generate Session.get("schemeMode")
    return false
  "click .icon-trash": (e) ->
    $swatch = $(e.srcElement or e.target)
    while not $swatch.hasClass "swatch"
      $swatch = $swatch.parent()
    index = $swatch.attr "data-index"
    colors = Session.get "colors"
    colors.splice index, 1
    Session.set "editActive", true if colors.length is 0
    Session.set "colors", colors
    Session.set "liftedColorIndex", null
  "click .icon-left": (e) ->
    $swatch = $(e.srcElement or e.target)
    while not $swatch.hasClass "swatch"
      $swatch = $swatch.parent()
    index = $swatch.attr "data-index"
    colors = Session.get "colors"
    color = colors.splice index, 1
    colors.splice index - 1, 0, color[0]
    Session.set "colors", colors
    Session.set "liftedColorIndex", null
  "click .icon-right": (e) ->
    $swatch = $(e.srcElement or e.target)
    while not $swatch.hasClass "swatch"
      $swatch = $swatch.parent()
    index = $swatch.attr "data-index"
    colors = Session.get "colors"
    color = colors.splice index, 1
    colors.splice index + 1, 0, color[0]
    Session.set "colors", colors
    Session.set "liftedColorIndex", null
  "click .icon-up": (e) ->
    $swatch = $(e.srcElement or e.target)
    while not $swatch.hasClass "swatch"
      $swatch = $swatch.parent()
    index = $swatch.attr("data-index") * 1
    Session.set "liftedColorIndex", index
  "click .icon-down": (e) ->
    Session.set "liftedColorIndex", null
  "click span[data-type]": (e) ->
    $span = $(e.srcElement or e.target)
    Session.set "displayColorType", $span.attr("data-type")
  "change input[type=text][data-type]": (e) ->
    $input = $(e.srcElement or e.target)
    type = $input.attr "data-type"
    key = $input.attr "data-key"
    value = $input.val()
    srcColorHsl = Session.get "currentColor"
    if not Template.scheme.isSchemeMode()
      srcColorHsl = Session.get("colors")[Session.get("liftedColorIndex")]
    srcColor = converter.convert("hsl", type, srcColorHsl)
    if type is "hex"
      bl = ~~(value.length / 3)
      srcColor.r = parseInt(new Array(4 - bl).join(value.substr(0 * bl, 1 * bl)), 16) / 255
      srcColor.g = parseInt(new Array(4 - bl).join(value.substr(1 * bl, 1 * bl)), 16) / 255
      srcColor.b = parseInt(new Array(4 - bl).join(value.substr(2 * bl, 1 * bl)), 16) / 255
    else
      value *= 1
      value /= converter.bounds[type][key].f
      srcColor[key] = value
    srcColorHsl = converter.convert(type, "hsl", srcColor)
    if Template.scheme.isSchemeMode()
      Session.set "currentColor", srcColorHsl
      converter.scheme.generate Session.get("schemeMode")
    else
      colors = Session.get "colors"
      colors[Session.get("liftedColorIndex")] = srcColorHsl
      Session.set "colors", colors
  "mouseup input[type=range]": (e) ->
    $range = $(e.srcElement or e.target)
    srcColorHsl = Session.get "currentColor"
    if not Template.scheme.isSchemeMode()
      srcColorHsl = Session.get("colors")[Session.get("liftedColorIndex")]
    type = Session.get("displayColorType")
    srcColor = converter.convert("hsl", type, srcColorHsl)
    key = $range.attr "data-key"
    value =
    srcColor[key] = ($range.val() * 1) / converter.bounds[type][key].f
    srcColorHsl = converter.convert(type, "hsl", srcColor)
    if Template.scheme.isSchemeMode()
      Session.set "currentColor", srcColorHsl
      converter.scheme.generate Session.get("schemeMode")
    else
      colors = Session.get "colors"
      colors[Session.get("liftedColorIndex")] = srcColorHsl
      Session.set "colors", colors

Template.menu.linkLess = () ->
  colorStr = "http://api.colourco.de/export/less/"
  for color, colorIndex in Session.get "colors"
    colorStr += "%2C" if colorIndex > 0
    colorStr += "%23"
    colorStr += converter.stringlify.hex(converter.convert("hsl", "hex", color)).substr(1)
  colorStr
Template.menu.linkImage = (hsl) ->
  colorStr = "http://api.colourco.de/export/png/"
  for color, colorIndex in Session.get "colors"
    colorStr += "%2C" if colorIndex > 0
    colorStr += "%23"
    colorStr += converter.stringlify.hex(converter.convert("hsl", "hex", color)).substr(1)
  colorStr
Template.menu.linkPerma = (hsl) ->
  colorStr = "/"
  if Session.equals "schemeMode", "none"
    colorStr += "none/"
    for color, colorIndex in Session.get "colors"
      colorStr += "%2C" if colorIndex > 0
      colorStr += "%23"
      colorStr += converter.stringlify.hex(converter.convert("hsl", "hex", color)).substr(1)
  else
    colorStr += "#{Session.get "schemeMode"}/#{Session.get("colors").length}/%23"
    colorStr += converter.stringlify.hex(converter.convert("hsl", "hex", Session.get "currentColor")).substr(1)
  colorStr

Meteor.startup () ->
  Meteor._reload.onMigrate () ->
    if confirm("The application has been updated!\nPress OK to restart the application.\n(The current status will maybe lost)")
      [true]
    else
      false
  path = window.location.pathname
  pathParts = path.split "/"
  if pathParts.length is 3 and pathParts[1] is "none"
    colorStrings = decodeURIComponent(pathParts[2]).split(",")
    colors = []
    for colorString, colorIndex in colorStrings
      if colorString.length is 7
        r = parseInt colorString.substr(1, 2), 16
        g = parseInt colorString.substr(3, 2), 16
        b = parseInt colorString.substr(5, 2), 16
        hsl = converter.convert "rgb", "hsl", {r: r / 255, g: g / 255, b: b / 255}
        colors.push hsl
        Session.set "currentColor", hsl
    if colors.length > 0
      Session.set "colors", colors
      Session.set "editActive", false
  if pathParts.length is 4
    colorString = decodeURIComponent(pathParts[3])
    if colorString.length is 7
      r = parseInt colorString.substr(1, 2), 16
      g = parseInt colorString.substr(3, 2), 16
      b = parseInt colorString.substr(5, 2), 16
      hsl = converter.convert "rgb", "hsl", {r: r / 255, g: g / 255, b: b / 255}
      Session.set "currentColor", hsl
    numColors = pathParts[2] * 1
    if numColors > 3 and numColors < 11
      colors = []
      for colorIndex in [1..numColors]
        colors.push {h: 0, s: 0, l: 0}
      Session.set "colors", colors
      Session.set "currentMenu", "menu-#{pathParts[1]}"
      Session.set "schemeMode", pathParts[1]
      Session.set "editActive", false
      converter.scheme.generate Session.get("schemeMode")

  $main = $ "#main"
  $pages = $main.children "div.page"
  isAnimating = false
  endCurrPage = false
  endNextPage = false
  animationEvents = 'animationend webkitAnimationEnd MSAnimationEnd oAnimationEnd'
  current = 0

  $pages.each () ->
    $page = $ @
    $page.data "originalClassList", $page.attr("class")

  $pages.eq(current).addClass("page-current")

  window.nextPage = (index) ->
    return false if isAnimating
    isAnimating = true;
    $currPage = $pages.eq current
    current = index

    $nextPage = $pages.eq(current)
    isAnimating = false if $nextPage.hasClass "page-current"
    return if $nextPage.hasClass "page-current"
    $nextPage.addClass("page-current")
    outClass = "page-rotateTopSideFirst"
    inClass = "page-moveFromTop page-delay200 page-ontop"

    $currPage.addClass(outClass).on animationEvents, () ->
      $currPage.off(animationEvents)
      endCurrPage = true
      onEndAnimation($currPage, $nextPage) if endNextPage

    $nextPage.addClass(inClass).on animationEvents, () ->
      $nextPage.off animationEvents
      endNextPage = true
      onEndAnimation($currPage, $nextPage) if endCurrPage

  wheelEvent = (e) ->
    delta = if (e.wheelDelta || e.detail || e.originalEvent.wheelDelta || e.originalEvent.detail) > 0 then 0.025 else -0.025
    hsl = Session.get "currentColor"
    hsl.s = Math.max(0, Math.min(1, hsl.s + delta))
    Session.set "currentColor", hsl if Session.equals "editActive", true
    converter.scheme.generate Session.get("schemeMode") unless Session.equals "schemeMode", "none"


  $("body").bind "mousewheel", wheelEvent
  $("body").bind "DOMMouseScroll", wheelEvent

  onEndAnimation = ($outpage, $inpage ) ->
    endCurrPage = false
    endNextPage = false
    resetPage $outpage, $inpage
    isAnimating = false

  resetPage = ($outpage, $inpage) ->
    $outpage.attr 'class', $outpage.data('originalClassList')
    $inpage.attr 'class', $inpage.data('originalClassList') + ' page-current'

  setTimeout () ->
    window.nextPage current + 1
  , 250

Template.analytics.rendered = ->
  if !window._gaq?
    window._gaq = []
    _gaq.push(['_setAccount', 'UA-29865051-1'])
    _gaq.push(['_setDomainName', 'colourco.de'])
    _gaq.push(['_trackPageview'])

    (->
      ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
      gajs = '.google-analytics.com/ga.js'
      ga.src = if 'https:' is document.location.protocol then 'https://ssl'+gajs else 'http://www'+gajs
      s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s)
    )()

