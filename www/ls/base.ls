scrollTween = (offset) ->
  ->
    interpolate = d3.interpolateNumber do
      window.pageYOffset || document.documentElement.scrollTop
      offset
    (progress) -> window.scrollTo 0, interpolate progress

window.smoothScroll = (offset) ->
  console.log offset
  d3.transition!
    .duration 800
    .tween "scroll" scrollTween offset
