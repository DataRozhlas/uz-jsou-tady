mesh = topojson.mesh do
  ig.data.evropa
  ig.data.evropa.objects.data
  (a, b) -> a isnt b

{features} = topojson.feature do
  ig.data.evropa
  ig.data.evropa.objects.data

width = 550
bounds = [[-16.7, 15], [37, 60.5]]
height = 400
projection = ig.utils.geo.getProjection bounds, width
path = d3.geo.path!
  ..projection projection
for feature in features
  feature.centroid = d3.geo.centroid feature
  feature.projectedCentroid = projection feature.centroid
  if feature.properties.country == "Norway"
    feature.projectedCentroid = [260 20]
  if feature.properties.country == "Sweden"
    feature.projectedCentroid = [320 40]

container = d3.select ig.containers['panic']
d3.select ig.containers['police-map']
  ..append \svg
    ..attr {width, height}
    ..selectAll \path .data features .enter!append \path
      ..attr \d path
  ..selectAll \span .data features .enter!append \span
    ..style \left -> "#{it.projectedCentroid.0}px"
    ..style \top -> "#{it.projectedCentroid.1}px"
    ..html -> ig.utils.formatNumber it.properties.policemen_

currentStep = 0
scrolled = no
maxStep = 2

d3.select document .on \keydown.panic ->
  return unless d3.event.keyCode in [32, 34, 40]
  return if d3.event.defaultPrevented
  if currentStep > maxStep
    return
  d3.event.preventDefault!
  d3.event.stopPropagation!
  {top} = ig.utils.offset container.node!
  currentStep++
  window.smoothScroll top + 500
