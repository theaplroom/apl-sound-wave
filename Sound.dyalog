:Namespace Sound
    ⎕IO←0

    :Namespace DEF
        SAMPLE_RATE ← 8192  ⍝ Default sample rate
        BIT_DEPTH   ← 16    ⍝ Default bit depth
    :EndNamespace ⍝ DEF

      New←{
        ⍝ ⍵ ←→ [Samples [SampleRate [BitDepth]]]
          9=⎕NC'⍵':⎕NS ⍵
          s←⎕NS''
          arg←⊂⍣(1=≡⍵)⊢⍵
          y Fs nBits←3↑arg,(≢arg)↓⍬ DEF.SAMPLE_RATE DEF.BIT_DEPTH
          s.Samples←⍪y
          s.SampleRate←Fs
          s.BitDepth←nBits
          s
      }


      Read←{
        ⍝ ⍵     ←→ file name
        ⍝ ←     ←→ wave ns object
          s←⎕NS''
          t←⍵ ⎕NTIE 0
          read←{⎕NREAD ⍺,⍵}
          c1←t 80∘read
          i1←t 83∘read
          i2←t 163∘read
          i4←t 323∘read
     
          signal←t∘{_←⎕NUNTIE ⍺ ⋄ ⍵ ⎕SIGNAL 11}
          rs←÷,⊢
          readFmt←{
              1≠⍵.Format←i2 1:signal'Unsupported format code: ',⍵.Format
              ⍵.NumChannels←i2 1    ⍝ number of channels
              ⍵.SampleRate←i4 1     ⍝ Number of samples per second
              ⍵.DataRate←i4 1       ⍝ Number of Bytes per sec
              ⍵.BlockAlign←i2 1     ⍝ Block Align
              0≠8|⍵.BitDepth←i2 1:signal'Unexpected bit depth: ',⍵.BitDepth
              _←c1 ⍺-16             ⍝ Ignore rest?!
              ⍵
          }
          readData←{
              d←i1 ⍺
              bits←11 ⎕DR,⌽(⍺ rs ⍵.BitDepth÷8)⍴d
              m←((≢bits)rs ⍵.BitDepth)⍴bits
              n←⊣/m
              v←2⊥⍉m
              (n/v)←-(2*⍵.BitDepth)|-n/v
              ⍵.Samples←((≢v)rs ⍵.NumChannels)⍴v
              ⍵
          }
     
          'RIFF'≢id←c1 4:signal'Unexpected chunk id: ',id
          size←i4 1
          'WAVE'≢id←c1 4:signal'Unexpected id: ',id
          _←{
              0∊⍴id←c1 4:⍵
              sz←i4 1
              id≡'fmt ':∇ sz readFmt ⍵
              id≡'data':∇ sz readData ⍵
              ∇ ⍵⊣⍎'⍵.',id,'←c1 sz'
          }s
          s⊣⎕NUNTIE t
      }

      Write←{
        ⍝ ⍵     ←→ wav object | y [Fs [nBits]]
        ⍝ ⍺     ←→ file name
        ⍝ ←     ←→ 0
          b←ToBytes ⍵
          t←⍺ ⎕NCREATE 0
          _←b ⎕NAPPEND t 83
          0⊣⎕NUNTIE t
      }

      ToBytes←{
        ⍝ ⍵     ←→ wav object | y [Fs [nBits]]
        ⍝ y     ←→ samples x channels ⋄  2=⍴⍴y
        ⍝ Fs    ←→ sample rate
        ⍝ nBits ←→ bits per sample
        ⍝ ←     ←→ wave byte array
     
          y Fs nBits←(New ⍵).(Samples SampleRate BitDepth)
     
          toByte←{83 ⎕DR⊃(⎕DR ⍵)⍺ ⎕DR ⍵}
          i4←323∘toByte
          i2←163∘toByte
          i1←83∘toByte
          samples channels←⍴y
          ba←channels×nBits÷8 ⍝ block align
     
          scaled←nBits{∧/1≥|⍵:⌊⍵×¯1+2*⍺-1 ⋄ ⌊⍵},y
          data←83 ⎕DR nBits{,⌽[1]((≢⍵),⍺(÷,⊢)8)⍴⍉(⍺/2)⊤⍵}scaled
     
          hdr←,i1'RIFF'     ⍝ RIFF format tag
          hdr,←i4 36+≢data  ⍝ Size to end of file from here, fill in later
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
          hdr,←i4≢data
          hdr,data
      }

      Play←{
        ⍝ ⍵ ←→ filename | wav object | wav byte array
        ⍝ ⍺ ←→ mode (combination of SND_ enumeration)
          ⍺←SND.SYNC
          ps←{}
          dr←10|⎕DR ⍵
          t v←dr{
              ⍺=0:'0T'⍵
              'I1[]'(ToBytes ⍵)
          }⍵
          m←2⊥∨/(5/2)⊤⍺(SND.MEMORY×dr≠0)
          bin←'ps'⎕NA'Winmm|PlaySound* <',t,' I U'
          ps v 0 m
      }


    :Namespace SND
        SYNC      ← 0  ⍝ play synchronously (default)
        ASYNC     ← 1  ⍝ play asynchronously
        NODEFAULT ← 2  ⍝ silence (!default) if sound not found
        MEMORY    ← 4  ⍝ pszSound points to a memory file
        LOOP      ← 8  ⍝ loop the sound until next sndPlaySound
        NOSTOP    ← 16 ⍝ don't stop any currently playing sound
    :EndNamespace ⍝ SND

:EndNamespace
