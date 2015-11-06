container = ig.containers['daily']
return unless container
container = d3.select container
values =
  1 # 29. - 30
  0 # 30 - 31
  1 # 31 - 1
  8 # 1 - 2
  2 # 2 -3 3188
  1 # 3 - 4
  13 # 4 - 5  - 3202
  3 # 5 - 6

height = 150
width = 600

padding = 10
dayWidth = (width - 2 * padding) / (values.length - 1)

ig.containers['daily-number'].innerHTML = values[*-1]

scaleY = d3.scale.linear!
  ..domain [(d3.max values), 0]
  ..range [padding, (height - 2 * padding)]

scaleX = (d, i) -> padding + (i + 0.5)* (dayWidth - 2 * padding)

svgContainer = d3.select ig.containers['daily-history'] .append \div
  ..attr \class \svg-container
svg = svgContainer.append \svg
  ..attr {width, height}

line = d3.svg.line!
  ..y scaleY
  ..x scaleX

svg.append \path
  ..attr \d line values

svg.selectAll \circle .data values .enter!append \circle
  ..attr \r 5
  ..attr \cx scaleX
  ..attr \cy scaleY

svgContainer.selectAll \span.label .data values .enter!append \span
  ..attr \class "label black-bold"
  ..html -> it
  ..style \left -> "#{scaleX ...}px"
  ..style \top -> "#{scaleY ...}px"
len = values.length
dates = values.map (d, i) ->
  d = new Date!
    ..setHours 12
  d.setTime d.getTime! - (len - i - 1) * 86400 * 1e3
  d
dayNames = <[Ne Po Út St Čt Pá So]>
svgContainer.selectAll \span.label-x .data dates .enter!append \span
  ..attr \class "label-x"
  ..html -> "#{it.getDate!}.<br><span>#{dayNames[it.getDay!]}</span>"
  ..style \left -> "#{scaleX ...}px"

scrolled = no
d3.select document .on \keydown.daily ->
  return unless d3.event.keyCode == 40
  return if scrolled
  scrolled := yes
  d3.event.preventDefault!
  d3.event.stopPropagation!
  height = container.node!offsetHeight
  window.smoothScroll height
