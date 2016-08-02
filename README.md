# apl-sound-wave

This project started out as a collaboration between Stuart Smith and Gilgamesh Athoraya to provide some basic signal processing tools for APL. Contributors are welcome, so feel free to join the project.

The tools are divided into three separate namespaces:
1. #.Sound - reads/writes wav files and plays arrays of samples in memory.
1. #.SoundFX - collection of sound effects and oscillators.
1. #.DSP - general signal processing tools like filters and transforms

## Examples

Examples can be found in the namespace `#.SoundExamples`, but here are some basice commands 
Create and play 3 seconds of 440Hz sine wave in single channel.
```
      a4←#.SoundFX.Sine 440 0 3 8192  
      Sound.Play a4 
```

Modulate previous wave across 2 channels.
```
      z←1 90 1 8192 #.SoundFX.Autopan a4
      rc←#.Sound.Play z 8192
```

Add attack/release effect
```
      zar←.1 .2 0 sr #.SoundFX.AR z
      #.Sound.Play zar sr
```

Read wav file
```
      snd←#.Sound.Read '.\wav\rooster.wav'
      ⎕NC'snd'
9
      #.Sound.Play snd
```

Write wav file
```
      '.\zar.wav'#.Sound.Write zar 8192 
```

