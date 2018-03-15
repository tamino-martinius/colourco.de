Session.setDefault "colors", []
Session.setDefault "currentColor", {h: 0, s: 0.5, l: 0.5}
Session.setDefault "currentMenu", "menu-none"
Session.setDefault "schemeMode", "none"
Session.setDefault "editActive", true
Session.setDefault "displayColorType", "hex"
Session.setDefault "liftedColorIndex", null

Meteor.startup () ->
  # Meteor._reload.onMigrate () ->
  #   if confirm("The application has been updated!\nPress OK to restart the application.\n(The current status will maybe lost)")
  #     [true]
  #   else
  #     false
  path = window.location.pathname
  pathParts = path.split "/"
  if pathParts.length is 4 and pathParts[1] is "none"
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
  if pathParts.length is 5
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
  current = 0

  $pages.eq(current).addClass("page-current")

  window.nextPage = (index) ->
    $pages.removeClass('page-current')
    $pages.eq(index).addClass("page-current")
    current = index

  wheelEvent = (e) ->
    delta = if (e.wheelDelta || e.detail || e.originalEvent.wheelDelta || e.originalEvent.detail) > 0 then 0.025 else -0.025
    hsl = Session.get "currentColor"
    hsl.s = Math.max(0, Math.min(1, hsl.s - delta))
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
