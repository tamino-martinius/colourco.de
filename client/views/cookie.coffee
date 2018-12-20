cookieStr = document.cookie;
cookie = {};
if (cookieStr)
  cookieStr.split(';').forEach (cookieProperty) ->
    if cookieProperty.indexOf('=') >= 0 and cookieProperty.split('=')[0].trim() is 'json'
      cookie = JSON.parse(cookieProperty.split('=')[1])

Template.cookie.helpers
  class: if cookie.cookieInfo then 'hidden' else ''

Template.cookie.events
  "click #cookie-info": (e) ->
    cookie.cookieInfo = true
    document.cookie = 'json=' + JSON.stringify(cookie) + ';max-age=31536000'
    $('#cookie-info').addClass('hidden')
