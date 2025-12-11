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

function play(base_freq=cfg["app"]["base_freq"], duration=cfg["app"]["duration"], amplitude_envelope=amplitude_envelope_linear)
    device = find_device("MacBook Air Speakers") # Replace with actual substring of your device nam
    # device = PortAudio.devices()[4]
    S = 44100 # sampling rate (samples / second)
    ns = duration * S # total number of samples
    x = amplitude_envelope(2ns) .* cos.(2pi*(1:2ns)*base_freq/S) #+ cos.(duration*pi*(1:ns)*base_freq*1.5/S) # A440 tone for 2 seconds
    PortAudioStream(device,0, 2; samplerate=S) do stream
           write(stream, x)
    end
end

function amplitude_envelope_linear(nsamples)
    attack = Int(nsamples * 0.1)
    decay = Int(nsamples * 0.1)
    sustain = nsamples - attack - decay
    env = vcat(range(0, stop=1, length=attack),
               ones(sustain),
               range(1, stop=0, length=decay))
    return env
end



play(220, 1)
play()