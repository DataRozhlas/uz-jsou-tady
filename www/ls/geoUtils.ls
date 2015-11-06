window.ig.utils.geo = geoUtils = {}
geoUtils.getFittingProjection = (features, width) ->
  bounds = geoUtils.getBounds features
  projection = geoUtils.getProjection bounds, width
  {width, height} = geoUtils.getDimensions bounds, projection
  {width, height, projection}

geoUtils.getBounds = (features) ->
  north = -Infinity
  west  = +Infinity
  south = +Infinity
  east  = -Infinity
  for feature in features
    [[w,s],[e,n]] = d3.geo.bounds feature
    if n > north => north = n
    if w < west  => west  = w
    if s < south => south = s
    if e > east  => east  = e
  [[west, south], [east, north]]

geoUtils.getProjection = ([[west, south], [east, north]]:bounds, width) ->
  displayedPercent = (Math.abs west - east) / 360
  projection = d3.geo.mercator!
    ..scale width / (Math.PI * 2 * displayedPercent)
    ..center [west, north]
    ..translate [0 0]

geoUtils.getDimensions = ([[west, south], [east, north]]:bounds, projection) ->
  [x0, y0] = projection [west, north]
  [x1, y1] = projection [east, south]
  width = (x1 - x0)
  height = (y1 - y0)
  {width, height}

