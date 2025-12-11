import TOML
using PortAudio

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

function play(base_freq=cfg["app"]["base_freq"], duration=cfg["app"]["duration"])
    device = find_device("MacBook Air Speakers") # Replace with actual substring of your device nam
    # device = PortAudio.devices()[4]
    S = 44100 # sampling rate (samples / second)
    x = cos.(2pi*(1:2S)*base_freq/S) + cos.(2pi*(1:2S)*base_freq*1.5/S) # A440 tone for 2 seconds
    PortAudioStream(device,0, 2; samplerate=S) do stream
           write(stream, x)
    end
end



play()