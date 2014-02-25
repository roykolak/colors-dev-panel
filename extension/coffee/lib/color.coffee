Panel.Lib.Color =
  Color: (hex) ->
    net.brehaut.Color(hex)

  range: (range, callback) ->
    (callback((100 / range) * i / 100) for i in [1..range])

  lighten: (options) ->
    @range options.steps, (decimal) =>
      @Color(options.rangeStart).lightenByRatio(decimal).toString()

  darken: (options) ->
    @range options.steps, (decimal) =>
      @Color(options.rangeStart).darkenByRatio(decimal).toString()

  saturate: (options) ->
    @range options.steps, (decimal) =>
      @Color(options.rangeStart).saturateByRatio(decimal).toString()

  desaturate: (options) ->
    @range options.steps, (decimal) =>
      @Color(options.rangeStart).desaturateByRatio(decimal).toString()

  blend: (options) ->
    blendColor = @Color(options.blendColor)
    @range options.steps, (decimal) =>
      @Color(options.rangeStart).blend(blendColor, decimal).toString()

  triadic: (hex) ->
    (color.toString() for color in @Color(hex).triadicScheme())

  complementary: (hex) ->
    (color.toString() for color in @Color(hex).complementaryScheme())

  analogous: (hex) ->
    (color.toString() for color in @Color(hex).analogousScheme())

  neutral: (hex) ->
    (color.toString() for color in @Color(hex).neutralScheme())

  tetradic: (hex) ->
    (color.toString() for color in @Color(hex).tetradicScheme())

  sixTone: (hex) ->
    (color.toString() for color in @Color(hex).sixToneCWScheme())

  toHexCSS: (hex) ->
    Color(hex).hexString()

  toRgbCSS: (hex) ->
    Color(hex).rgbString()

  toHslCSS: (hex) ->
    Color(hex).hslString()
