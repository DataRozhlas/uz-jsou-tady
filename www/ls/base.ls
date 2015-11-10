scrollTween = (offset) ->
  ->
    interpolate = d3.interpolateNumber do
      window.pageYOffset || document.documentElement.scrollTop
      offset
    (progress) -> window.scrollTo 0, interpolate progress

window.smoothScroll = (offset) ->
  d3.transition!
    .duration 800
    .tween "scroll" scrollTween offset

(err, values) <~ d3.tsv "../data/data.tsv", (row) ->
  for field, value of row
    row[field] = parseInt value, 10
  row.date = new Date!
    ..setTime 0
    ..setDate row.day
    ..setMonth row.month - 1
    ..setFullYear row.year
  row

ig.drawDaily values
ig.drawYearly values[*-1]
shares = d3.select ".shares"
shares.select "a[target='_blank']" .on \click ->
  window.open do
    @getAttribute \href
    ''
    "width=550,height=265"
