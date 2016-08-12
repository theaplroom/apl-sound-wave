:Namespace SoundExamples

    SR←44100

    ∇ RunAll
      {⍎⎕←⍵}¨(⎕NL-3)~⊂⊃⎕SI
    ∇

    ∇ Autopan;w;z;rc;sig;sr
      w←#.Sound.Read'.\wav\moore_guitar.wav'
      sig sr←w.(Samples SampleRate)
      ⎕←'Autopan 2Hz'
      z←2 90 0.3 sr #.SoundFX.Autopan sig
      rc←#.Sound.Play z
      ⎕←'Autopan 4Hz'
      z←4 90 0.3 sr #.SoundFX.Autopan sig
      rc←#.Sound.Play z
    ∇

    ∇ Crossfade;x;y;z;sin;saw;sqr;rc
      ⎕←'Suzanne Vega: "Tom''s Diner"'
      x←#.Sound.Read'.\wav\Toms_diner.wav'
      rc←#.Sound.Play x
      ⎕←'Gary Moore: "Still Got the Blues"'
      y←#.Sound.Read'.\wav\moore_guitar.wav'
      rc←#.Sound.Play y
      ⎕←'7-second crossfade'
      z←7 x.SampleRate #.SoundFX.Crossfade(x y).Samples
      rc←#.Sound.Play z
      ⎕←'combine three waves with 1 sec overlap'
      sin←#.SoundFX.Sine 440 0 2 SR
      saw←#.SoundFX.Sawtooth 445 0 3 SR
      sqr←#.SoundFX.Square 450 0 4 SR
      z←⊃{1 SR #.SoundFX.Crossfade ⍺ ⍵}/sin saw sqr
      rc←#.Sound.Play z SR
     ⍝
    ∇

    ∇ DTMF;rc;all
      ⎕←'All DTMF keys'
      all←SR #.SoundFX.DTMF ⎕D,'ABCD*#'
      rc←#.Sound.Play all
    ⍝
    ∇

    ∇ Envelope;sig;ctrl;right;⎕IO;x;rc
      ⎕IO←1
      ⎕←'Make an A440 test sine tone'
      sig←#.SoundFX.Sine 440 0 2 SR
      rc←#.Sound.Play sig SR
      ⎕←'Apply linear Attack/Release envelope'
      rc←#.Sound.Play 0.1 0.7 0 SR #.SoundFX.AR sig
      ⎕←'Apply exponential Attack/Release envelope'
      rc←#.Sound.Play 0.1 0.7 1 SR #.SoundFX.AR sig
      ⎕←'Apply 4-segment custom envelope'
      ctrl←(1 0.5 0.25 0)(0.05 0.1 1 0.7)#.SoundFX.Envelope SR
      rc←#.Sound.Play ctrl #.SoundFX.VCA sig
     ⍝
    ∇

    ∇ Filter;x;f;bins;inds;h;z;rc;b
      ⎕←'Generate signal with 1kHz + 3kHz wave'
      x←#.SoundFX.Sine 1000 0 2 SR
      x+←#.SoundFX.Sine 3000 0 2 SR
      x←#.SoundFX.Normalize x
      rc←#.Sound.Play x SR
      ⎕←'Create ideal frequency domain filter to remove 3kHz wave'
      bins←256
      inds←(⍳6)+¯3+⌊3000×bins÷SR
      f←bins⍴1
      f[inds]←0
      f[bins-inds-1]←0
      ⎕←'Use iFFT to get B coefficients for filter'
      h←(⌊0.5×≢f)⌽9○1 #.DSP.FFT f
      b←h×#.DSP.Triangle≢h
      z←b 1 #.DSP.Filter x
      rc←#.Sound.Play z
     
      ⎕←'Create bandstop filter using FIR'
      b←#.DSP.FIR 512(2800 3200÷SR÷2)
      z←b 1 #.DSP.Filter x
      rc←#.Sound.Play z
     
      ⎕←'Create bandpass filter using FIR'
      b←0 #.DSP.FIR 512(2800 3200÷SR÷2)
      z←b 1 #.DSP.Filter x
      rc←#.Sound.Play z
     ⍝
    ∇

    ∇ FLT;sig;rc
      ⎕←'Hit the resonant bandpass filter with a unit impulse'
      sig←(3×SR)↑1
      rc←#.Sound.Play 1000 0.25 SR #.SoundFX.FLT sig
    ∇

    ∇ FM_Instrument;y;rc
   ⍝ A sampling of the different kinds of sounds that can be achieved with a single algorithm.
   ⍝ Some knowledge of FM theory is necessary to use fm_instr effectively.
   ⍝
      ⎕←'Bell'
      y←#.SoundFX.FM_Instr 200 0.7143 10(1 0.5 0.25 0.125 0.06)(0.01 3 3 3 3)SR
      rc←#.Sound.Play y SR
     
      ⎕←'Wood drum'
      y←⊃#.SoundFX.FM_Instr 200 0.7143 2(1,0.01,0)(0.001,0.025,0.2)SR
      y←y,y,y,y
      rc←#.Sound.Play y SR
     
      ⎕←'Bassoon'
      y←#.SoundFX.FM_Instr 500 5 1.5(0.25 0.5 1 1 0.33 0.16 0)(0.033 0.033 0.033 0.5 0.02 0.02 0.02)SR
      rc←#.Sound.Play y SR
     
      ⎕←'Clarinet'
      y←#.SoundFX.FM_Instr 900 1.5 4(0.25 0.5 1 1 0.33 0.16 0)(0.033 0.033 0.033 0.5 0.02 0.02 0.02)SR
      rc←#.Sound.Play y SR
     
      ⎕←'Brass'
      y←#.SoundFX.FM_Instr 440 1 5(1 0.75 0.7 0)(0.1 0.1 0.3 0.1)SR
      rc←#.Sound.Play y SR
      ⍝
    ∇

    ∇ Leslie;x;sig;sr;rc
      ⎕←'Rotating loudspeaker (Leslie) effect'
      x←#.Sound.Read'.\wav\claire_oubli_flute.wav'
      sig sr←x.(Samples SampleRate)
      rc←#.Sound.Play sig sr
      rc←#.Sound.Play 5 0.3 0.0007 sr #.SoundFX.Leslie sig
    ∇

    ∇ Noise;sig;rc
      ⎕←'3-second noise burst with exponential envelope'
      sig←#.SoundFX.Noise 3 SR
      rc←#.Sound.Play 0.01 2.99 1 SR #.SoundFX.AR sig
    ∇


    ∇ Psycho;sig;rc
      ⎕←'Psychoacoustic experiment: slightly mis-tuned tones in stereo...'
      sig←⍪#.SoundFX.Sine 440 0 4 SR
      sig,←#.SoundFX.Sine 443 0 4 SR
      rc←#.Sound.Play sig SR
      ⎕←'...and mono'
      sig←0.5×+/sig
      rc←#.Sound.Play sig SR
    ∇

    ∇ Resample;x;rc;x512;x1792;x4032;x864
      x←#.SoundFX.Sine 100 0 2 512
      x+←#.SoundFX.Sine 140 0 2 512
      x+←#.SoundFX.Sine 200 0 2 512
      x512←#.SoundFX.Normalize x
      ⎕←'Play wave at Fs=512Hz'
      rc←#.Sound.Play x512 512
      x1792←7 2 #.DSP.Resample x512
      ⎕←'Play wave upsampled to Fs=1792Hz'
      rc←#.Sound.Play x1792 1792
      x4032←9 4 #.DSP.Resample x1792
      ⎕←'Play wave upsampled to Fs=4032Hz'
      rc←#.Sound.Play x4032 4032
      x864←3 14 #.DSP.Resample x4032
      ⎕←'Play wave downsampled to Fs=864Hz'
      rc←#.Sound.Play x864 864
      ⍝
    ∇

    ∇ Reverb;⎕IO;x;z;b;rc;sig;sr
      ⎕IO←0
      ⎕←'Play dry sound'
      x←#.Sound.Read'.\wav\artoffugue.wav'
      rc←#.Sound.Play x
      ⎕←'"artificial" reverb'
      sig sr←⊣/¨x.(Samples SampleRate)
      z←2 8 sr #.SoundFX.Reverb sig
      rc←#.Sound.Play z
      ⎕←'"natural" reverb'
      b←#.Sound.Read'.\wav\SydneyOperaHouse01.wav'
      z←x.SampleRate #.DSP.Convolve,¨(x b).Samples
      rc←#.Sound.Play z
    ∇

    ∇ Sequencer;midi;dur;wave;rc;y;x;osc;sine
      ⎕←'Play a tune specified by midi numbers for pitches and note durations given in seconds.'
      midi←71 71 67 67 67 69 71 71 69 67 66 69 69 66 67 69 66 71 67 64 62
      dur←0.5 1 0.5 0.5 1 0.5 0.5 1 0.5 0.5 1.5 0.5 1 0.5 0.5 0.5 0.5 0.5 0.5 2 1
      ⎕←'Play using Sine wave table'
      sine←{(7159⌶)⊃⎕NGET ⍵}'.\wave_table\sine.json'
      y←sine #.SoundFX.{⍺∘Oscillator Sequencer ⍵}midi dur SR
      rc←#.Sound.Play y
      ⎕←'Play using Sine wave generator'
      y←#.SoundFX.{Sine Sequencer ⍵}midi dur SR
      rc←#.Sound.Play y
      ⎕←'Play using FM instrument: Clarinet'
      rc←#.Sound.Play #.SoundFX.{FM_Clarinet Sequencer ⍵}(12+midi)dur SR
      ⎕←'Play using FM instrument: Basson'
      rc←#.Sound.Play #.SoundFX.{FM_Basson Sequencer ⍵}midi dur SR
      ⎕←'Play using samples from wav file'
      x←#.Sound.Read'.\wav\Toms_diner.wav'
      wave←(2*16)↑,x.Samples
      osc←wave x.SampleRate∘#.SoundFX.FM_Sample
      rc←#.Sound.Play osc #.SoundFX.Sequencer midi(0.7×dur)SR
     ⍝
    ∇

    ∇ Tremolo;sig;rc
      ⎕←'Play a tone with varying amounts of tremolo'
      sig←#.SoundFX.Sine 330 0 2 SR
      rc←#.Sound.Play 3 0.1 SR #.SoundFX.Tremolo sig
      rc←#.Sound.Play 3 0.2 SR #.SoundFX.Tremolo sig
      rc←#.Sound.Play 3 0.4 SR #.SoundFX.Tremolo sig
      rc←#.Sound.Play 3 0.8 SR #.SoundFX.Tremolo sig
    ∇

    ∇ VCF;ctrl;sig;rc
      ⎕←'Make a 220 sawtooth test tone'
      sig←#.SoundFX.Sawtooth 220 0 2 SR
      rc←#.Sound.Play sig
      ⎕←'"Wow" the tone'
      ctrl←#.DSP.Hamming⌈0.5×SR
      rc←#.Sound.Play 50 1000 50 ctrl SR #.SoundFX.VCF sig
    ∇

    ∇ Vibrato;sig;rc
      ⎕←'Play a tone with varying amounts of vibrato'
      sig←#.SoundFX.Sine 330 0 2 SR
      rc←#.Sound.Play 3 0.003 0.003 SR #.SoundFX.Vibrato sig
      rc←#.Sound.Play 3 0.003 0.009 SR #.SoundFX.Vibrato sig
      rc←#.Sound.Play 3 0.01 0.02 SR #.SoundFX.Vibrato sig
      ⍝
    ∇

:EndNamespace
