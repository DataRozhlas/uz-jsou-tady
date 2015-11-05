container = ig.containers['daily-history']
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

height = 150
width = 600

padding = 10
dayWidth = (width - 2 * padding) / (values.length - 1)

scaleY = d3.scale.linear!
  ..domain [(d3.max values), 0]
  ..range [padding, (height - 2 * padding)]

scaleX = (d, i) -> padding + (i + 0.5)* (dayWidth - 2 * padding)

svgContainer = container.append \div
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

svgContainer.selectAll \span .data values .enter!append \span
  ..attr \class "label black-bold"
  ..html -> it
  ..style \left -> "#{scaleX ...}px"
  ..style \top -> "#{scaleY ...}px"
