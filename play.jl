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
    ns = duration * S # total number of samples
    x = amplitude_envelope(2ns) .* cos.(2pi*(1:2ns)*base_freq/S) #+ cos.(duration*pi*(1:ns)*base_freq*1.5/S) # A440 tone for 2 seconds
    PortAudioStream(device,0, 2; samplerate=S) do stream
           write(stream, x)
    end
end





play(220, 1)
play()