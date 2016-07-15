:Namespace DSP
    ⎕IO←0

    dft←{⍵+.×*0J1×○2×(∘.×⍨⍳N)÷N←≢⍵}

      dit2fft←{
        ⍝ ⍵ ←→ samples
        ⍝ ⍺ ←→ mode (0 = normal, 1 = inverse)
          ⍺←0
          bro←{⍵⌷⍨⊂2⊥⊖2⊥⍣¯1⊢⍳≢⍵}
          fs←*-⍣⍺⊢{0J1×○2×(⍳⍵)÷⍵}¨2*1+⍳2⍟≢⍵
          pair←{,⍨⍪⍵}
          process←{
              1=≢⍵:,⍵
              m←(≢⍵)⍴1 0
              a←pair m⌿⍵
              b←pair(~m)⌿⍵
              l←a+(⍺⊃fs)×[1]b
              (⍺+1)∇ l
          }
          (÷≢⍵)×⍣⍺⊢0 process bro ⍵
      }

:EndNamespace
