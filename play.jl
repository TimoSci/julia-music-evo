import TOML
using PortAudio

include( "./envelopes.jl")
# using .envelopes: amplitude_envelope_linear

cfg = TOML.parsefile("config.toml")

function find_device(name_substring)
    devices = PortAudio.devices()
    for (i, device) in enumerate(devices)
        if occursin(name_substring, device.name)
            return device
        end
    end
    error("Device with name containing '$name_substring' not found.")
end


function play(base_freq=cfg["app"]["base_freq"], duration=cfg["app"]["duration"], amplitude_envelope=amplitude_envelope_linear, sample_rate=cfg["app"]["sample_rate"])
    device = find_device("MacBook Air Speakers") # Replace with actual substring of your device nam
    S = sample_rate # sampling rate (samples / second)
    sine = make_instrument(harmonic_wave,S, amplitude_envelope)
    x = sine(base_freq, duration)
    PortAudioStream(device,0, 2; samplerate=S) do stream
           write(stream, x)
    end
end

function make_instrument(wave=sinewave,S=cfg["app"]["sample_rate"], amplitude_envelope=amplitude_envelope_linear)
     function instrument(freq,total_duration)
         ns = total_duration * S 
         amplitude_envelope(2ns) .* wave(2ns,freq,S)
         #+ cos.(duration*pi*(1:ns)*base_freq*1.5/S) # A440 tone for 2 seconds
     end   
     return instrument
end

# Basic sine wave generator
function sinewave(sample_number,frequency,sample_rate)
   return sin.(2pi*(1:sample_number)*frequency/sample_rate) 
end

# Harmonic wave generator
function harmonic_wave(sample_number,frequency,sample_rate,harmonics=[0.5,0.25,0.125])
   wave = zeros(sample_number)
   for (i,amp) in enumerate(harmonics)
       wave .+= amp .* sinewave(sample_number, frequency*(i), sample_rate)
   end
   return wave
end





play(220, 1)
play()