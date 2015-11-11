window.JsonParser =
  run: (element)->
    JSON.parse(element.replace(/&quot;/g,'"')) if element
