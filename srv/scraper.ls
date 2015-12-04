require! request
require! fs
data = fs.readFileSync "#__dirname/../data/data.tsv" .toString!
lastDay = data.split "\n"
  .filter (.length)
  .pop!
  .split "\t"
  .0
lastDay = parseInt lastDay, 10
yesterday = new Date!
  ..setTime Date.now! - 86400 * 1e3
if yesterday.getDate! is lastDay
  console.log "Already there"
  return
maxAttempts = 20
attempts = 0
download = ->
  attempts++
  if attempts > maxAttempts
    clearInterval interval
  try
    (err, response, body) <~ request.get do
      url: "http://www.mvcr.cz/migrace/clanek/aktualni-statistiky.aspx"
      gzip: yes
    return unless body
    body .= replace /&nbsp;/g ' '
    fs.writeFileSync "#__dirname/../data/scraped/#{Date.now!}.html", body
    dataLines = body.match /[0-9 ]+ osob.?/gi
    if dataLines.1.match /([0-9]+)\./
      [_, dayInReport] = that
      dayInReport = parseInt dayInReport, 10
      return if dayInReport  != yesterday.getDate!
    [sum, count] = for line in dataLines
      numberPart = line.split ":" .pop!
      numberPart .= replace /[^0-9]/g ''
      parseInt numberPart, 10

    row =
      yesterday.getDate!
      yesterday.getMonth! + 1
      yesterday.getFullYear!
      count
      sum
    data += row.join "\t"
    data += "\n"
    console.log data
    fs.writeFileSync do
      "#__dirname/../data/data.tsv"
      data
    clearInterval interval
  catch e
    console.log e

interval = setInterval download, 600 * 1e3
download!
