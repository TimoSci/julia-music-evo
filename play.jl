using PortAudio

function play()
    device = PortAudio.devices()[4]
    S = 44100 # sampling rate (samples / second)
    x = cos.(2pi*(1:2S)*440/S) + cos.(2pi*(1:2S)*660/S) # A440 tone for 2 seconds
    PortAudioStream(device,0, 2; samplerate=S) do stream
           write(stream, x)
    end
end



play()