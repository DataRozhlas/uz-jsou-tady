ig.drawYearly = (lastDatum) ->
  container = ig.containers['total']
  return unless container
  container = d3.select container
  class Year
    (@year, @value, @special) ->
  startTime = new Date!
    ..setTime 0
    ..setFullYear 2016
    ..setMonth 0
    ..setDate 1
  timeSoFar = lastDatum.date.getTime! - startTime.getTime!
  percentSpent = timeSoFar / (365 * 86400 * 1e3)
  extrapolated = (lastDatum.sum - 3292) / percentSpent
  years =
    new Year lastDatum.date.getFullYear!, extrapolated, 'non-ex'
    new Year 2015, 6008
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
  # ig.containers['total-extrapolated'].innerHTML = ig.utils.formatNumber extrapolated
  dir = if 8096 > extrapolated then "méně" else "více"
  # ig.containers['total-comparison-absolute'].innerHTML = "#{ig.utils.formatNumber Math.abs 8096 - extrapolated} #{dir}"
  # ig.containers['total-comparison-ratio'].innerHTML = "#{ig.utils.formatNumber 27391 / extrapolated} × méně"


  xScale = ->
    year = it.year || it
    (year - 2004) / (2015 - 2003) * 100

  yScale = d3.scale.linear!
    ..domain [0 27391]
    ..range [0 100]

  num = ig.utils.formatNumber
  maxStep = 2
  ig.containers['total-number'].innerHTML = num lastDatum.sum - 3292

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
            ..html -> num it.value
        ..append \div
          ..attr \class \label-x
          ..html -> it.year

  targetOffset = null
  step = ->
    container.selectAll ".step"
      ..transition!
        ..delay (d, i) -> i * 100
        ..attr \class "bar-container step active"
  calcOffset = ->
    {top} = ig.utils.offset container.node!
    targetOffset := top + container.node!offsetHeight / 2

  calcOffset!
  setInterval calcOffset, 1000
  animated = no
  window.addEventListener \scroll ->
    top = (document.body.scrollTop || document.documentElement.scrollTop) + window.innerHeight || 0
    if top > targetOffset and not animated
      animated := yes
      step!
