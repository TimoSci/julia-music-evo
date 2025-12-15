

   function amplitude_envelope_linear(nsamples::Int)
        attack = Int(round(nsamples * 0.1))
        decay = Int(round(nsamples * 0.1))
        println("attack: $attack, decay: $decay")
        sustain = nsamples - attack - decay

        env = vcat(range(0, stop=1, length=attack),
                ones(sustain),
                range(1, stop=0, length=decay))
        return env
    end

