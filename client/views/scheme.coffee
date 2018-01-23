isSchemeMode = () -> result = not Session.equals "schemeMode", "none"

Template.scheme.helpers
  colors: () ->
    res = Session.get "colors"
    res[i].$index = i for color, i in res
    if res.length > 0
      res[0].$first = true
      res[res.length - 1].$last = true
    res
  currentColor: () -> Session.get "currentColor"
  editActive: () -> Session.get "editActive"
  isLifted: (index) -> Session.equals "liftedColorIndex", index
  isSchemeMode: isSchemeMode
  isCenter: (index) -> Math.floor(Session.get("colors").length / 2) is index
  bounds: () -> converter.bounds[Session.get "displayColorType"]
  factorizedColorValue: (hsl, key) ->
    type = Session.get("displayColorType")
    Math.round(converter.convert("hsl", type, hsl)[key] * converter.bounds[type][key].f)
  displayColorType: (type) -> Session.get "displayColorType"
  getColor: (hsl, type) ->
    new Handlebars.SafeString converter.stringlify[type](converter.convert("hsl", type, hsl))
  getColorTag: (hsl, type) ->
    new Handlebars.SafeString converter.stringlify[type](converter.convert("hsl", type, hsl),"b")
  colorBack: (hsl) -> converter.stringlify.rgb(converter.convert("hsl", "rgb", hsl))
  markerLeft: (hsl) -> "#{hsl.h * 100}%"
  markerTop : (hsl) -> "#{hsl.l * 100}%"
  colorFore: (hsl) -> converter.stringlify.fgc(converter.convert("hsl", "fgc", hsl))
  linkPerma: (hsl) ->
    hex = converter.stringlify.hex(converter.convert("hsl", "hex", hsl)).substr(1)
    "/none/%23#{hex}"
  editColor: (type, hsl) ->
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
        value = Math.round(color[key] * bound.f)
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
  colorSlider: () ->
    type = Session.get "displayColorType"
    hsl = Session.get "currentColor"
    if not isSchemeMode()
      liftedColorIndex = Session.get("liftedColorIndex")
      return unless liftedColorIndex?
      hsl = Session.get("colors")[liftedColorIndex]
    color = converter.convert "hsl", type, hsl
    rows = ""
    for key, bound of converter.bounds[type]
      value = Math.round(color[key] * bound.f)
      min = bound.min * bound.f
      max = bound.max * bound.f
      valueTag = ""
      valueTag = "value=\"#{value}\""
      gradientSteps = 11
      gradientRange = bound.max - bound.min
      gradientStep = gradientRange / gradientSteps
      gradient = ""
      for stepIndex in [0..gradientSteps]
        percentage = (100 / gradientSteps) * stepIndex
        gradientValue = bound.min + gradientStep * stepIndex
        gradientColor = jQuery.extend {}, color
        gradientColor[key] = gradientValue
        rgb = converter.stringlify.rgb(converter.convert type, "rgb", gradientColor)
        gradient += "--bg-#{stepIndex}: #{rgb};"
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
          <col width="30px" />
          <col width="*" />
          <col width="50px" />
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
    h = (e.pageX - offset.left) / Math.round($swatch.width() * 0.99)
    l = (e.pageY - offset.top) / $swatch.height()
    hsl = {h: h, s: color.s, l: l}
    Session.set "currentColor", hsl
  "mousemove .edit-scheme": (e) ->
    color = Session.get "currentColor"
    $swatches = $(e.srcElement or e.target)
    while not $swatches.hasClass "swatches"
      $swatches = $swatches.parent()
    offset = $swatches.offset()
    h = (e.pageX - offset.left - $swatches.width() * 0.05) / Math.round($swatches.width() * 0.9)
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
  # "click .icon-lock": (e) ->
  #   Session.set "editActive", true
  #   Session.set "liftedColorIndex", null
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
  "click .pos-t": (e) ->
    $swatch = $(e.srcElement or e.target)
    while not $swatch.hasClass "swatch"
      $swatch = $swatch.parent()
    index = $swatch.attr "data-index"
    colors = Session.get "colors"
    colors.splice index, 1
    Session.set "editActive", true if colors.length is 0
    Session.set "colors", colors
    Session.set "liftedColorIndex", null
  "click .pos-l": (e) ->
    $swatch = $(e.srcElement or e.target)
    while not $swatch.hasClass "swatch"
      $swatch = $swatch.parent()
    index = $swatch.attr "data-index"
    colors = Session.get "colors"
    color = colors.splice index, 1
    colors.splice index - 1, 0, color[0]
    Session.set "colors", colors
    Session.set "liftedColorIndex", null
  "click .pos-r": (e) ->
    $swatch = $(e.srcElement or e.target)
    while not $swatch.hasClass "swatch"
      $swatch = $swatch.parent()
    index = $swatch.attr "data-index"
    colors = Session.get "colors"
    color = colors.splice index, 1
    colors.splice index + 1, 0, color[0]
    Session.set "colors", colors
    Session.set "liftedColorIndex", null
  "click .swatch:not(.lifted) .pos-b": (e) ->
    $swatch = $(e.srcElement or e.target)
    while not $swatch.hasClass "swatch"
      $swatch = $swatch.parent()
    index = $swatch.attr("data-index") * 1
    Session.set "liftedColorIndex", index
  "click .swatch.lifted .pos-b": (e) ->
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
    if not isSchemeMode()
      srcColorHsl = Session.get("colors")[Session.get("liftedColorIndex")]
    srcColor = converter.convert("hsl", type, srcColorHsl)
    if type is "hex"
      value = value.replace /^#+/g, ""
      bl = Math.round(value.length / 3)
      srcColor.r = parseInt(new Array(4 - bl).join(value.substr(0 * bl, 1 * bl)), 16) / 255
      srcColor.g = parseInt(new Array(4 - bl).join(value.substr(1 * bl, 1 * bl)), 16) / 255
      srcColor.b = parseInt(new Array(4 - bl).join(value.substr(2 * bl, 1 * bl)), 16) / 255
    else
      value *= 1
      value /= converter.bounds[type][key].f
      srcColor[key] = value
    srcColorHsl = converter.convert(type, "hsl", srcColor)
    if isSchemeMode()
      Session.set "currentColor", srcColorHsl
      converter.scheme.generate Session.get("schemeMode")
    else
      colors = Session.get "colors"
      colors[Session.get("liftedColorIndex")] = srcColorHsl
      Session.set "colors", colors
  "keydown input[type=text][data-type]": (e) ->
    keyCode = e.keyCode
    if 37 <= keyCode <= 40
      $input = $(e.srcElement or e.target)
      type = $input.attr "data-type"
      key = $input.attr "data-key"
      value = $input.val()
      srcColorHsl = Session.get "currentColor"
      if not isSchemeMode()
        srcColorHsl = Session.get("colors")[Session.get("liftedColorIndex")]
      srcColor = converter.convert("hsl", type, srcColorHsl)
      if type is "hex"
        value = value.replace /^#+/g, ""
        bl = Math.round(value.length / 3)
        srcColor.r = parseInt(new Array(4 - bl).join(value.substr(0 * bl, 1 * bl)), 16) / 255
        srcColor.g = parseInt(new Array(4 - bl).join(value.substr(1 * bl, 1 * bl)), 16) / 255
        srcColor.b = parseInt(new Array(4 - bl).join(value.substr(2 * bl, 1 * bl)), 16) / 255
      else
        value *= 1
        value += if keyCode is 37 or keyCode is 40 then -1 else +1
        value /= converter.bounds[type][key].f
        srcColor[key] = value
      srcColorHsl = converter.convert(type, "hsl", srcColor)
      if isSchemeMode()
        Session.set "currentColor", srcColorHsl
        converter.scheme.generate Session.get("schemeMode")
      else
        colors = Session.get "colors"
        colors[Session.get("liftedColorIndex")] = srcColorHsl
        Session.set "colors", colors
      setTimeout () ->
        $("input[type=text][data-type=#{type}][data-key=#{key}]").focus()
      , 50
  "mouseup input[type=range]": (e) ->
    $range = $(e.srcElement or e.target)
    srcColorHsl = Session.get "currentColor"
    if not isSchemeMode()
      srcColorHsl = Session.get("colors")[Session.get("liftedColorIndex")]
    type = Session.get("displayColorType")
    srcColor = converter.convert("hsl", type, srcColorHsl)
    key = $range.attr "data-key"
    value =
    srcColor[key] = ($range.val() * 1) / converter.bounds[type][key].f
    srcColorHsl = converter.convert(type, "hsl", srcColor)
    if isSchemeMode()
      Session.set "currentColor", srcColorHsl
      converter.scheme.generate Session.get("schemeMode")
    else
      colors = Session.get "colors"
      colors[Session.get("liftedColorIndex")] = srcColorHsl
      Session.set "colors", colors
