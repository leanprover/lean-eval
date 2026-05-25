import LeanEval.KnotTheory.Prelude

namespace LeanEval
namespace KnotTheory

/-!
# PL closure of a braid word

For `n : ℕ` and `word : List ℤ` interpreted as a braid word on `n` strands
(`+i` is the generator `σ_i`, the crossing of strand `i` over strand
`i + 1`; `-i` is `σ_i⁻¹`), `braidClosure n word` produces the vertex list
of the *Markov closure* traced as a single polyline component starting at
strand position `1`. For braid words whose closure is a knot, this traces
the entire knot; for multi-component link closures it traces only the
component containing position `1`.

Coordinate layout. Strands sit at integer `x`-positions `1, …, n`. The
braid box spans `z ∈ [-word.length, 0]`, one unit of `z`-depth per
crossing. Over-strands lift to `y = 1`, under-strands stay at `y = 0`,
designed so that the two strands of any crossing are `y`-separated.
Closure arcs swing through `y = 100`, well outside the braid box.

The layout *intends* to produce a simple polyline, but simplicity is not
proved here; it is a separate obligation discharged by the user
constructing a `PLKnot` (which carries an `isSimple` field). The
function is silent on invalid input — `|w| = 0` or `|w| ≥ n` — and
produces garbage in those cases.
-/

namespace BraidClosure

/-- Construct an `R3` element from three coordinates `(x, y, z)`. -/
noncomputable def mkR3 (x y z : ℝ) : R3 :=
  WithLp.toLp 2 (fun i : Fin 3 =>
    if i.val = 0 then x else if i.val = 1 then y else z)

/-- Traversal state: the current strand position and the accumulated
vertex list of the polyline so far. -/
structure State where
  /-- Current strand `x`-position. -/
  pos : ℕ
  /-- Polyline vertices accumulated so far, in order. -/
  vertices : List R3

/-- Apply one braid generator to the traversal state. The crossing
occupies the `z`-slab `[zBot, zTop]` (with `zBot < zTop`). The braid
generator is `w = ±i`; we cross strands at positions `i` and `i + 1`,
with `i = w.natAbs`. -/
noncomputable def applyCrossing (state : State) (w : ℤ) (zTop zBot : ℝ) : State :=
  let i : ℕ := w.natAbs
  let p : ℕ := state.pos
  let zMidHi : ℝ := zTop - (zTop - zBot) / 4
  let zMidLo : ℝ := zBot + (zTop - zBot) / 4
  if p = i then
    -- We are at the lower-index strand of the crossing; we swap to position `i + 1`.
    if 0 < w then
      -- σ_i: lower strand goes OVER. Lift to `y = 1`, swap, drop.
      { pos := i + 1
        vertices := state.vertices ++
          [ mkR3 (i : ℝ) 1 zMidHi,
            mkR3 ((i + 1 : ℕ) : ℝ) 1 zMidLo,
            mkR3 ((i + 1 : ℕ) : ℝ) 0 zBot ] }
    else
      -- σ_i⁻¹: lower strand goes UNDER. Stay at `y = 0`, swap.
      { pos := i + 1
        vertices := state.vertices ++ [ mkR3 ((i + 1 : ℕ) : ℝ) 0 zBot ] }
  else if p = i + 1 then
    -- We are at the upper-index strand of the crossing; we swap to position `i`.
    if 0 < w then
      -- σ_i: we are the UNDER strand.
      { pos := i
        vertices := state.vertices ++ [ mkR3 (i : ℝ) 0 zBot ] }
    else
      -- σ_i⁻¹: we are the OVER strand.
      { pos := i
        vertices := state.vertices ++
          [ mkR3 ((i + 1 : ℕ) : ℝ) 1 zMidHi,
            mkR3 (i : ℝ) 1 zMidLo,
            mkR3 (i : ℝ) 0 zBot ] }
  else
    -- Not participating in this crossing; descend straight.
    { state with vertices := state.vertices ++ [ mkR3 (p : ℝ) 0 zBot ] }

/-- Apply all braid generators in `word` starting from crossing index `k`,
accumulating vertices in `state`. -/
noncomputable def applyWord : State → List ℤ → ℕ → State
  | state, [], _ => state
  | state, w :: ws, k =>
      let state' := applyCrossing state w (-(k : ℝ)) (-((k : ℝ) + 1))
      applyWord state' ws (k + 1)

/-- One pass through the braid box plus a closure arc. If the pass ends
at position `1`, the closure arc closes back to the polyline's starting
vertex `(1, 0, 0)` and we omit the redundant final vertex. Otherwise
we continue at the top of the new position. -/
noncomputable def onePass (word : List ℤ) (state : State) : State :=
  let afterBraid := applyWord state word 0
  let m : ℝ := word.length
  let p : ℕ := afterBraid.pos
  let arc :=
    if p = 1 then
      [ mkR3 (p : ℝ) 100 (-m), mkR3 (p : ℝ) 100 0 ]
    else
      [ mkR3 (p : ℝ) 100 (-m), mkR3 (p : ℝ) 100 0, mkR3 (p : ℝ) 0 0 ]
  { pos := p, vertices := afterBraid.vertices ++ arc }

/-- Iterate passes until back at position `1`, bounded by `fuel` to
guarantee termination (we visit at most `n` distinct strand positions). -/
noncomputable def iterate (word : List ℤ) : ℕ → State → State
  | 0, state => state
  | f + 1, state =>
      let s' := onePass word state
      if s'.pos = 1 then s' else iterate word f s'

end BraidClosure

/-- The PL closure of a braid word on `n` strands, traced as one polyline
component starting at strand position `1`. -/
noncomputable def braidClosure (n : ℕ) (word : List ℤ) : List R3 :=
  if word.length = 0 then
    -- Junk fallback for the empty-word case (no PL data to derive).
    [BraidClosure.mkR3 0 0 0, BraidClosure.mkR3 1 0 0, BraidClosure.mkR3 0 1 0]
  else
    let init : BraidClosure.State :=
      { pos := 1, vertices := [BraidClosure.mkR3 1 0 0] }
    (BraidClosure.iterate word n init).vertices

end KnotTheory
end LeanEval
