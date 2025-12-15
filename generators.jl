# Basic sine wave generator
function sinewave(sample_number,frequency,sample_rate)
   return sin.(2pi*(1:sample_number)*frequency/sample_rate) 
end

#TODO make this generator lazyly evaluated to save memory
# Harmonic wave generator
function harmonic_wave(sample_number,frequency,sample_rate,harmonics=[0.5,0.25,0.125,0.0625,0.03125])
   wave = zeros(sample_number)
   for (i,amp) in enumerate(harmonics)
       wave .+= amp .* sinewave(sample_number, frequency*(i), sample_rate)
   end
   return wave
end

