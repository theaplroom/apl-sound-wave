:Namespace DSP
    ⎕IO←0

      Convolve←{
        ⍝ ⍵ ←→ signalA signalB
          ⎕IO←0
          tfm←⊃×/FFT¨↓↑⍵
          z÷⌈⌿|z←9○1 FFT tfm
      }


    DFT←{⍺←0 ⋄ (÷N)×⍣⍺⊢x+.×*0J1×○2×(∘.×⍨⍳N)÷N←≢x←¯1⌽∘⌽⍣⍺⊢⍵}

      FFT←{
        ⍝ ⍵ ←→ samples
        ⍝ ⍺ ←→ mode (0 = normal, 1 = inverse)
          ⍺←0
          bro←{⍵⌷⍨⊂2⊥⊖2⊥⍣¯1⊢⍳≢⍵}
          N←2*nl←⌈2⍟ol←≢⍵
          fs←*-⍣⍺⊢{0J1×○2×(⍳⍵)÷⍵}¨2*1+⍳nl
          pair←{,⍨⍪⍵}
          process←{
              1=≢⍵:,⍵
              m←(≢⍵)⍴1 0
              a←pair m⌿⍵
              b←pair(~m)⌿⍵
              l←a+(⍺⊃fs)×[1]b
              (⍺+1)∇ l
          }
          ol↑(÷N)×⍣⍺⊢0 process bro N↑⍵
      }

      Filter←{
        ⍝ ⍺ ←→ B A coefficients
        ⍝ ⍵ ←→ signal Fs
          ⎕IO←0
          bl←≢⊃b a←⍺
          sig←⍵,0⍴⍨pad←⌊bl÷2
          sl←≢sig
          x←(bl⍴0),sig
          y←sl⍴0
          bs←1+⍣{(bl≤s)∨0=s←⍺|≢y}⊢⌊bl÷⍨2*20
          feedforward←{
              ⍵≥≢y:0
              inds←⍵+⍳bs+bl
              top←-inds+.≥≢x
              v←(-⍳≢b)⌽b∘.×(⊂top↓inds)⌷x
              y[top↓⍵+⍳bs]←bl↓+⌿v
              ∇ ⍵+bs
          }
          feedback←{
              ⍺=1:⍵
              y←(0⍴⍨≢⍺),⍵
              inds←1↓{⍵/⍳⍴⍵}0≠a←,⍺
              a←a[inds]
              _←{0⊣y[⍵]-←+/a×y[⍵-inds]}¨(≢⍺)↓⍳≢y
              (≢⍺)↓y
          }
          _←feedforward 0
          yx←a feedback y
          pad↓yx
      }

      FilterInt←{
        ⍝ Interpolation filter
        ⍝ ⍺ ←→ (B coefficients) (L factor)
        ⍝ ⍵ ←→ signal
          ⎕IO←0
          bl←≢⊃b L←⍺
          sig←⍵
          sig,←0⍴⍨pad←⌊bl÷2
          x←sig↑⍨-bl+≢sig
          y←0⍴⍨L×≢sig
          bs←1+⍣{(bl≤s)∨0=s←⍺|≢y}⊢⌊bl÷⍨2*20
          fb←(L,⍨bl÷L)⍴b
          feedforward←{
              ⍵≥≢y:0
              inds←⍵+⍳bs+bl
              top←-inds+.≥≢x
              v←fb∘.×(⊂top↓inds)⌷x
              vx←,bl↓⍉+⌿(-⊃¨⍳⍴fb)⌽v
              y[(L×⍵)+⍳≢vx]←vx
              ∇ ⍵+bs
          }
          _←feedforward 0
          yx←(-L×pad)↓pad⌽y
          yx
      }

      Resample←{
        ⍝ ⍺ ←→ L M
        ⍝      L = interpoLation factor
        ⍝      M = deciMation factor
        ⍝ ⍵ ←→ signal
          ⎕IO←0
          L M←⍺÷∨/⍺
          taps←L+⍣{(31<⍺)∧0=2|⍺}⊢2×L×1⌈⌈M÷L
          h←FIR taps(1÷L⌈M)
          y←h L FilterInt ⍵
          z←{⍵/⍨(M↑1)⍴⍨≢⍵}y
          z÷⌈⌿|z
      }

      FIR←{
         ⍝ Generate a FIR filter
         ⍝ ⍵ ←→ n Wn
         ⍝      n     = order of filter
         ⍝      Wn    = scalar or vector of cutoff frequencies
         ⍝              as proportions of Fn (Nyquist freq)  [0,1)
         ⍝ ⍺ ←→ 0 = highpass/bandpass; 1 = lowpass/bandstop
         ⍝ ← ←→ B filter coefficients
          ⎕IO←0
          ⍺←1
          n Wn←⍵
          i←⌈n÷2
          m←≠\+/(⍳i)∘.=⌊i×,Wn
          f←,∘⌽⍨~⍣⍺⊢m
          ~1∊f:'Higher order required for precisions requested'⎕SIGNAL 11
          h←(⌊0.5×≢f)⌽9○1 DFT f
          h×Hamming≢h
      }

    :Section Windows
      Blackman←{⎕IO←0
          ⍺←0.16
          0.5×(1-⍺)+(⍺×2○○4×n)-2○○2×n←(⍳⍵)÷⍵-1
      }

      Hamming←{⎕IO←0
          ⍺←0.54
          ⍺-(1-⍺)×2○○2×(⍳⍵)÷⍵-1
      }

      Triangle←{⎕IO←0
          1-|⍵÷⍨2×(⍳⍵)-0.5×⍵-1
      }

      Welch←{⎕IO←0
          1-(((⍳⍵)-N)÷N←0.5×⍵-1)*2
      }
    :EndSection ⍝ Windows

:EndNamespace
