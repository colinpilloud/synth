#!/usr/bin/env ruby

require 'ffi-portaudio'
require 'radspberry'
require 'curses'
include DSP

MODES = [ Phasor.new, SuperSaw.new, RpmSquare.new ]

@notes_map = { "C"   => 261.63,
               "C#"  => 277.18,
               "D"   => 293.66,
               "D#"  => 311.13,
               "E"   => 329.63,
               "F"   => 349.23,
               "F#"  => 369.99,
               "G"   => 392.00,
               "G#"  => 415.30,
               "A"   => 440.00,
               "A#"  => 466.16,
               "B"   => 493.88,
               "C5"  => 523.25,
               "C#5" => 554.37,
               "D5"  => 587.33,
               "D#5" => 622.25,
               "E5"  => 659.26
             }

def write(row, col, text)
  Curses.setpos(row, col)
  Curses.addstr(text);
end

def draw row, col, file
  File.open(file, "r").lines.each_with_index do |line, i|
    write(row + i, col, line)
  end
end

def draw_note note
  draw 1, 50, "./ascii/#{note[0]}"
  if note.include?("#")
    draw 1, 59, "./ascii/sharp"
  end
end

def play_note note
  return if @last_known.eql?(note)
  draw_note(note)
  Speaker.synth.freq = @notes_map[note]
  Speaker.unmute
  @last_known = note
end

def circular_shift arr
  x = arr.shift
  arr << x
  return x
end

def switch_mode
  Speaker[ circular_shift(MODES) ]
end

def octave_change direction
  if direction.eql?("up")
    @notes_map = @notes_map.inject({}) { |h,(k,v)| h[k] = v * 2; h }
  else
    @notes_map = @notes_map.inject({}) { |h,(k,v)| h[k] = v / 2; h }
  end
end

def init_screen
  Curses.noecho # do not show typed keys
  Curses.timeout = 450
  Curses.init_screen
  Curses.stdscr.keypad(true) # enable arrow keys
  begin
    yield
  ensure
    Curses.close_screen
    exit
  end
end

init_screen do
  switch_mode
  Speaker.mute

  write(10, 0, "` to quit, space bar to change mode, < and > to change octaves")
  draw(1, 4, "./ascii/piano")
  loop do
    case Curses.getch
    when ?a then play_note "C"
    when ?w then play_note "C#"
    when ?s then play_note "D"
    when ?e then play_note "D#"
    when ?d then play_note "E"
    when ?f then play_note "F"
    when ?t then play_note "F#"
    when ?g then play_note "G"
    when ?y then play_note "G#"
    when ?h then play_note "A"
    when ?u then play_note "A#"
    when ?j then play_note "B"
    when ?k then play_note "C5"
    when ?o then play_note "C#5"
    when ?l then play_note "D5"
    when ?p then play_note "D#5"
    when ?; then play_note "E5"
    when ' ' then switch_mode
    when '>', '.' then octave_change("up")
    when '<', ',' then octave_change("down")
    when ?` then break
    when nil
      Speaker.mute
      @last_known = nil
    end
  end

  exit
end
