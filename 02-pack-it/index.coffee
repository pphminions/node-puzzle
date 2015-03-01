
exports.pack = (data, cb) ->
  packedData = ''
  # convert the array of true and false values to a string on '1' and '0'
  for val in data
    if val == true
        packedData += 1
    else
        packedData += 0

  # split the string in to chunks of size 8
  split = packedData.match(/.{1,8}/g);

  packedData = ''
  # convert the string with binary data to a string of char representing each 8-bits of binary data
  for val in split
    # convert the 8-bit binary value to a decimal value
    digit = parseInt(val, 2)

    # convert the decimal value to a uni-code char
    char = String.fromCharCode(digit)
    packedData += char

  cb null, packedData


exports.unpack = (buffer, cb) ->
  unpackedData = []
  # split the char array to an array of single chars
  split = buffer.split("")

  fullBinaryStr = ''
  # convert the char array back in to a string of binary digits
  for val in split
    # get the decimal char code of each char
    digit = val.charCodeAt(0)

    # convert the decimal char code to a string of binary
    binary = (+digit).toString(2)

    # pad the binary string so that everything is a chunk of 8
    binaryStr = String("00000000" + binary).slice(-8)
    fullBinaryStr += binaryStr

  # split the binary array to and array of single digits
  split = fullBinaryStr.split("")

  # convert the array of '1' and '0' to an array of true and false
  for val in split
    if val == "1"
        unpackedData.push true
    else
        unpackedData.push false

  cb null, unpackedData

