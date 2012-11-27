#!/usr/bin/env ruby

require 'ffi-portaudio'
require 'radspberry'
include DSP

puts "starting"
Speaker[ Phasor.new ]
sleep 1
puts "changing frequency"
Speaker.synth.freq /= 2
sleep 1
puts "changing frequency"
Speaker.synth.freq /= 2
sleep 1
puts "muting"
Speaker.mute
