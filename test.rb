#!/usr/bin/env ruby

require 'bundler'
require 'wavefile'
include WaveFile

format = Format.new(:mono, 16, 44100)
writer = Writer.new("my_file.wav", format)

# Write a 1 second long 440Hz square wave
cycle = ([10000] * 50) + ([-10000] * 50)
buffer = Buffer.new(cycle, format)
220.times do
  writer.write(buffer)
end

writer.close()

`playsound my_file.wav`
