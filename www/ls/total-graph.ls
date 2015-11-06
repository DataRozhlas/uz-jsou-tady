container = ig.containers['total']
return unless container
container = d3.select container
class Year
  (@year, @value, @special) ->
years =
  new Year 2015, 3205, 'non-ex'
  # new Year 2015, 4446
  new Year 2014, 4822
  new Year 2013, 4153
  new Year 2012, 3595
  new Year 2011, 3360
  new Year 2010, 2988
  new Year 2009, 4457
  new Year 2008, 3829
  new Year 2007, 8096
  new Year 2006, 11488
  new Year 2005, 15489
  new Year 2004, 27391

width = 600

xScale = ->
  year = it.year || it
  (year - 2004) / (2015 - 2003) * 100

yScale = d3.scale.linear!
  ..domain [0 27391]
  ..range [0 100]

num = ig.utils.formatNumber
maxStep = 2
ig.containers['total-number'].innerHTML = num years.0.value
ig.containers['total-number']
historyContainer = d3.select ig.containers['total-history']
  ..append \div
    ..attr \class \bars
    ..selectAll \.bar-container .data years .enter!append \div
      ..attr \class (d, i) -> "bar-container step step-#{Math.min maxStep, i}"
      ..style \left -> "#{xScale ...}%"
      ..style \width "#{xScale 2005}%"
      ..attr \data-year (.year)
      ..append \div
        ..attr \class \bar
        ..style \height -> "#{yScale it.value}%"
        ..append \div
          ..attr \class \label-y
          ..html -> num it.value / 1e3, 1
      ..append \div
        ..attr \class \label-x
        ..html -> it.year

currentStep = 0
d3.select document .on \keydown.total ->
  return unless d3.event.keyCode == 40
  return if d3.event.defaultPrevented
  return if currentStep > maxStep
  d3.event.preventDefault!
  d3.event.stopPropagation!
  if not prestepped then prestep! else step!

prestepped = no
prestep = ->
  return if prestepped
  prestepped := yes
  historyContainer.selectAll \.bar-container .filter (-> it.year is 2015)
    ..select \.bar
      ..style \height -> "#{yScale 4446}%"
    ..select \.label-y
      ..html num 4446 / 1e3, 1
  container.select \.prestep .classed \active yes

step = ->
  container.selectAll ".step-#{currentStep}"
    ..transition!
      ..delay (d, i) -> i * 100
      ..attr \class "bar-container step active"
  currentStep++
step!
