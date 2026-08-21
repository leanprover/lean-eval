import ChallengeDeps
import Submission

open LorentzianPolynomials
open Finsupp Matrix MvPolynomial UpperHalfPlane

theorem theorem_2_25 (n d : ℕ) (hn : 0 < n) : closure (Ŀ n d) = L n d := by
  exact Submission.theorem_2_25 n d hn
