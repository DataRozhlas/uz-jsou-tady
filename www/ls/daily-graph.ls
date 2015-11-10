ig.drawDaily = (values) ->
  container = ig.containers['daily']
  return unless container
  container = d3.select container


  values .= slice -7


  height = 150
  width = 600

  padding = 10
  dayWidth = (width - 2 * padding) / (values.length - 1)

  ig.containers['daily-number'].innerHTML = values[*-1].count
  ig.containers['daily-number-count'].innerHTML =
    | 1 == values[*-1].count => "migranta"
    | 1 < values[*-1].count < 5 => "migranty"
    | otherwise => "migrantů"

  scaleY = d3.scale.linear!
    ..domain [(d3.max values.map (.count)), 0]
    ..range [padding, (height - 2 * padding)]

  scaleX = (d, i) -> padding + (i + 0.5)* (dayWidth - 2 * padding)

  svgContainer = d3.select ig.containers['daily-history'] .append \div
    ..attr \class \svg-container
  svg = svgContainer.append \svg
    ..attr {width, height}

  line = d3.svg.line!
    ..y -> scaleY it.count
    ..x scaleX

  svg.append \path
    ..attr \d line values

  svg.selectAll \circle .data values .enter!append \circle
    ..attr \r 5
    ..attr \cx scaleX
    ..attr \cy -> scaleY it.count

  svgContainer.selectAll \span.label .data values .enter!append \span
    ..attr \class "label black-bold"
    ..html -> it.count
    ..style \left -> "#{scaleX ...}px"
    ..style \top -> "#{scaleY it.count}px"
  len = values.length

  dayNames = <[Ne Po Út St Čt Pá So]>
  svgContainer.selectAll \span.label-x .data values .enter!append \span
    ..attr \class "label-x"
    ..html -> "#{it.date.getDate!}.<br><span>#{dayNames[it.date.getDay!]}</span>"
    ..style \left -> "#{scaleX ...}px"

  scrolled = no
  d3.select document .on \keydown.daily ->
    return unless d3.event.keyCode in [32, 34, 40]
    return if scrolled
    scrolled := yes
    d3.event.preventDefault!
    d3.event.stopPropagation!
    height = container.node!offsetHeight
    window.smoothScroll height
