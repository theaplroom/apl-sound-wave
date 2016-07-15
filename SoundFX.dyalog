:Namespace SoundFX
    ⎕IO←0

      AR←{
        ⍝ ⍵  ←→ (wave object)
        ⍝ ⍺  ←→ (at) (rt)
        ⍝ at ←→ attack time in seconds
        ⍝ rt ←→ release time in seconds
          ⍺←0.3 0.7
          at rt←⍺
          at FadeIn rt FadeOut ⍵
      }

      FadeIn←{
        ⍝ ⍵ ←→ (wave object)
        ⍝ ⍺ ←→ duration
        ⍝ ← ←→ wave
          ⍺←1
          0 ⍺ Fade ⍵
      }

      FadeOut←{
        ⍝ ⍵ ←→ (wave object)
        ⍝ ⍺ ←→ duration
        ⍝ ← ←→ (wave object)
          ⍺←1
          1 ⍺ Fade ⍵
      }

      Fade←{
        ⍝ ⍵   ←→ (wave object)
        ⍝ ⍺   ←→ (dir) (dur)
        ⍝ dir ←→ 0 = in, 1 = out
        ⍝ dur ←→ duration in seconds
        ⍝ ← ←→ (wave object)
          ⍺←0 1
          dir dur←⍺
          s←##.Sound.New ⍵
          n←⌊dur×s.SampleRate
          p←(i←⍳n⌊c←≢s.Samples)÷n
          i←(c-1)-⍣dir⊢i
          s.Samples[i;]←s.Samples[i;]×[0]p
          s
      }

:EndNamespace
