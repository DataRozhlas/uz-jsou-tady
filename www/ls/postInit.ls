if $
  $ "link" .remove!

  $ "body"
    .html ''
    .html ig.data.text
containers = document.querySelectorAll '.ig'
if not containers.length
  document.body.className += ' ig'
  window.ig.containers.base = document.body
else
  for container in containers
    window.ig.containers[container.getAttribute 'data-ig'] = container

style = document.createElement 'style'
    ..innerHTML = ig.data.style
font1 = document.createElement \link
  ..href = 'https://fonts.googleapis.com/css?family=Roboto:400,400italic,100,300,300italic&subset=latin,latin-ext'
  ..rel = 'stylesheet'
  ..type = 'text/css'

font2 = document.createElement \link
  ..href = 'https://fonts.googleapis.com/css?family=Roboto+Condensed:700'
  ..rel = 'stylesheet'
  ..type = 'text/css'


document.getElementsByTagName 'head' .0
  ..appendChild style
  ..appendChild font1
  ..appendChild font2
