#!/usr/bin/env ruby

require 'ffi-portaudio'
require 'radspberry'
include DSP

def play_note f, duration = 0.5
  Speaker.synth.freq = f
  sleep duration
end

def rest(time)
  Speaker.mute
  sleep time
  Speaker.unmute
end

Speaker[ Phasor.new ]
play_note 329.63
play_note 293.66
play_note 261.63
play_note 293.66
play_note 329.63
rest 0.05
play_note 329.63
rest 0.05
play_note 329.63
rest 0.5
play_note 293.66
rest 0.05
play_note 293.66
rest 0.05
play_note 293.66
rest 0.5
play_note 329.63
rest 0.05
play_note 392.00
rest 0.05
play_note 392.00
rest 0.5
play_note 329.63
play_note 293.66
play_note 261.63
play_note 293.66
play_note 329.63
rest 0.05
play_note 329.63
rest 0.05
play_note 329.63
rest 0.05
play_note 329.63
play_note 293.66
rest 0.05
play_note 293.66
play_note 329.63
play_note 293.66
play_note 261.63, 1.5
