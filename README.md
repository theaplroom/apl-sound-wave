# apl-sound-wave

Simple tool to create and play wav stream from arrays of samples. The `Wave` function returns a byte array that can either be played in memory or written to file (as a `.wav` file).

## Example

Create and play 3 seconds of 440Hz sine wave in single channel.
```
      x←   1○  8192{○(⍳3×⍺)×2×⍵÷⍺}440  
      Sound.Play x 
```

Modulate previous wave across 2 channels.
```
      y←⍉1 2∘.○8192{○(⍳3×⍺)×2×⍵÷⍺}1
      Sound.Play x×[1]y
```

Add attack/release effect
```
      Sound.Play SoundFX.AR x×[1]y
```

Read wav file
```
      snd←Sound.Read '.\rooster.wav'
      ⎕NC'snd'
9
      Sound.Play snd
```

Write wav file
```
      x←   1○  8192{○(⍳3×⍺)×2×⍵÷⍺}440  
      '.\a4.wav'Sound.Write x 
```

