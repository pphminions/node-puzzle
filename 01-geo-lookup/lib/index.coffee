fs = require 'fs'


GEO_FIELD_MIN = 0
GEO_FIELD_MAX = 1
GEO_FIELD_COUNTRY = 2


exports.ip2long = (ip) ->
  ip = ip.split '.', 4
  return +ip[0] * 16777216 + +ip[1] * 65536 + +ip[2] * 256 + +ip[3]


longindex = []
longdata = {}
exports.load = ->
  data = fs.readFileSync "#{__dirname}/../data/geo.txt", 'utf8'
  data = data.toString().split '\n'

  for line in data when line
    line = line.split '\t'
    # GEO_FIELD_MIN, GEO_FIELD_MAX, GEO_FIELD_COUNTRY
    # put GEO_FIELD_MIN in an array
    longindex.push +line[0]

    # create an object with the GEO_FIELD_MIN as keys and the other data as the values
    longdata[+line[0]] = [+line[0], +line[1], line[3]]

  # sort the longindex array.
  # using the custom function to sort numerically since the default is sort alphabetically.
  longindex.sort (a, b) -> a-b


normalize = (row) -> country: row[GEO_FIELD_COUNTRY]


exports.lookup = (ip) ->
  return -1 unless ip

  find = this.ip2long ip

  # find the index of the closest MIN value which is lower than the long value of the IP
  i = binarySearch(longindex, (x) -> x - find )

  if i > 0
    # get the data from that index
    line = longdata[longindex[i]]
    return normalize line

  return null


binarySearch = (arr, compare) ->
  # binary search, with custom compare function.
  # this will return the index of the closest value in array which is lower than the given value
  l = 0
  r = arr.length - 1
  while l <= r
    m = l + (r - l >> 1)
    comp = compare(arr[m])
    if comp < 0
      l = m + 1
    else if comp > 0
      r = m - 1
    else
      return m
  l - 1
