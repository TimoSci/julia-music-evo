using PortAudio

function find_device(name_substring)
    devices = PortAudio.devices()
    for (i, device) in enumerate(devices)
        if occursin(name_substring, device.name)
            return device
        end
    end
    error("Device with name containing '$name_substring' not found.")
end

function play(base_freq=440, duration=2)
    device = find_device("MacBook Air Speakers") # Replace with actual substring of your device nam
    # device = PortAudio.devices()[4]
    S = 44100 # sampling rate (samples / second)
    x = cos.(2pi*(1:2S)*440/S) + cos.(2pi*(1:2S)*660/S) # A440 tone for 2 seconds
    PortAudioStream(device,0, 2; samplerate=S) do stream
           write(stream, x)
    end
end



play()