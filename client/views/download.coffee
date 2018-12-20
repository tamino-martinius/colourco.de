Template.download.events
  "click .close": (e) ->
    nextPage(0)

Template.download.helpers
  colorStr: () ->
    colorStr = ""
    for color, colorIndex in Session.get "colors"
      colorStr += ";" if colorIndex > 0
      colorStr += converter.stringlify.hex(converter.convert("hsl", "hex", color))
    colorStr
  linkImage: (hsl) ->
    colorStr = "http://api.colourco.de/export/png/"
    for color, colorIndex in Session.get "colors"
      colorStr += "%2C" if colorIndex > 0
      colorStr += "%23"
      colorStr += converter.stringlify.hex(converter.convert("hsl", "hex", color)).substr(1)
    colorStr
  linkPerma: (hsl) ->
    colorStr = "/"
    if Session.equals "schemeMode", "none"
      colorStr += "freebuild/"
      for color, colorIndex in Session.get "colors"
        colorStr += "-" if colorIndex > 0
        colorStr += converter.stringlify.hex(converter.convert("hsl", "hex", color)).substr(1)
    else
      colorStr += "#{Session.get "schemeMode"}/#{Session.get("colors").length}/"
      colorStr += converter.stringlify.hex(converter.convert("hsl", "hex", Session.get "currentColor")).substr(1)
    colorStr
