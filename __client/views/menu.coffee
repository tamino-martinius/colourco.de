Template.menu.helpers
  menuClass: (cssClass, name) ->
    if Session.equals("currentMenu", name) then cssClass + ' active' else cssClass
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
      colorStr += "none/"
      for color, colorIndex in Session.get "colors"
        colorStr += "%2C" if colorIndex > 0
        colorStr += "%23"
        colorStr += converter.stringlify.hex(converter.convert("hsl", "hex", color)).substr(1)
    else
      colorStr += "#{Session.get "schemeMode"}/#{Session.get("colors").length}/%23"
      colorStr += converter.stringlify.hex(converter.convert("hsl", "hex", Session.get "currentColor")).substr(1)
    colorStr

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