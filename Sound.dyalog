:Namespace Sound

      Wave←{
        ⍝ ⍵     ←→ y [Fs [nBits]]
        ⍝ y     ←→ samples x channels ⋄  2=⍴⍴y
        ⍝ Fs    ←→ sample rate
        ⍝ nBits ←→ bits per sample
     
          arg←⊂⍣(1=≡⍵)⊢⍵
          y Fs nBits←3↑arg,(≢arg)↓⍬ 8192 16
     
          toByte←{83 ⎕DR⊃(⎕DR ⍵)⍺ ⎕DR ⍵}
          i4←323∘toByte
          i2←163∘toByte
          i1←83∘toByte
          samples channels←⍴y
          ba←channels×nBits÷8 ⍝ block align
     
          s←83 ⎕DR nBits{∧/1≥|⍵:⌊⍵×¯1+2*⍺-1 ⋄ ⍵},y
     
          hdr←,i1'RIFF'     ⍝ RIFF format tag
          hdr,←i4 36+≢s     ⍝ Size to end of file from here, fill in later
          hdr,←i1'WAVE'     ⍝ .WAV tag
     
          hdr,←i1'fmt '     ⍝ Format tag
          hdr,←i4 16        ⍝ Size of Format chunk
          hdr,←i2 1         ⍝ Format tag WAVE_FMT_PCM
          hdr,←i2 channels  ⍝ number of channels
          hdr,←i4 Fs        ⍝ Number of samples a second
          hdr,←i4 Fs×ba     ⍝ Number of Bytes per sec
          hdr,←i2 ba        ⍝ Block Align
          hdr,←i2 nBits     ⍝ Number of bits in each sample
     
          hdr,←i1'data'     ⍝ Data Block tag
          hdr,←i4≢s
          hdr,s
      }

      PlaySound←{
        ⍝ ⍵ ←→ name of file or buffer of wav data
        ⍝ ⍺ ←→ mode (combination of SND_ enumeration)
          ⍺←0
          ps←{}
          t←(⎕IO+0=10|⎕DR ⍵)⊃'I1[]' '0T'
          bin←'ps'⎕NA'Winmm|PlaySound* <',t,' I U'
          ps ⍵ 0 ⍺
      }

    SND_SYNC      ← 0  ⍝ play synchronously (default)
    SND_ASYNC     ← 1  ⍝ play asynchronously
    SND_NODEFAULT ← 2  ⍝ silence (!default) if sound not found
    SND_MEMORY    ← 4  ⍝ pszSound points to a memory file
    SND_LOOP      ← 8  ⍝ loop the sound until next sndPlaySound
    SND_NOSTOP    ← 16 ⍝ don't stop any currently playing sound

:EndNamespace
