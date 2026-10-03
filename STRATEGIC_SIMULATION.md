# Strategic Candidate Simulation, Moles & Spoiler Visualizations

This document captures the motivation, game-theoretic design, physics evolution,
and empirical tuning behind the `strategic-simulation` branch across
[`vote_simulation`](vote_simulation/), [`vote_widgets`](vote_widgets/), and
[`vote_demo`](vote_demo/).

---

## 1. The Core Thesis: _Why_ We Built This & Why It Matters

Previously, [`vote_demo`](vote_demo/) was a **static spatial calculator**: a
user dragged candidates around "Vote Town" and inspected the resulting election
tables.

Static snapshots, however, miss the most important real-world dynamic of voting
systems: **the election method itself changes how candidates behave, where they
campaign, and how vulnerable an election is to accidental or bad-faith
spoilers.**

We designed the simulation around three interconnected scenarios:

1. **Scenario 1 — Selfish Strategic Candidates**:
   > _"I want to imagine candidates playing strategically in each of the
   > scenarios like an agent. The candidate knows that it's in a Plurality
   > election or an IRV election or a Condorcet election... they start out
   > randomly and take turns moving within a bounded distance from their current
   > location, and the candidates don't know how many moves they have—they just
   > want to position themselves well. My theory is that if candidates act
   > selfishly, we can see how an election method affects how candidates
   > position themselves."_
2. **Scenario 2 — The Mole (`2a: Help A Win` & `2b: Make A Lose`)**:
   > _"Imagine you have $N$ candidates (likely small-ish, 3–4), but one of them
   > is a **MOLE**—their only goal is to either (a) help a specific candidate
   > win or (b) try to make a specific candidate lose. Same simulation model as
   > the first thing, but the mole doesn't care about winning itself... just
   > affecting the outcome."_
3. **Scenario 3 — Visualizing Why $>2$ Candidates Ruins Plurality**:
   > _"Some clear visualization of how more than 2 candidates RUINS plurality
   > elections. Because you have the possibility of a spoiler (unintentionally
   > or intentionally)."_

### Why This Is Interesting & Important

| Voting Method           | What Happens With Selfish Candidates (Scenario 1)                                                                                                                                                                                                                       | What Happens With a Mole (`+A` Kingmaker / `−A` Saboteur) (Scenario 2)                                                                                                                                                                                                                  | Core Takeaway for the Viewer                                                                                                                           |
| :---------------------- | :---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :----------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Plurality**           | **2 candidates**: Both march to the center `(75, 75)` (Median Voter Theorem / Hotelling's Law).<br>**$3+$ candidates**: **No stable equilibrium.** A candidate trapped in the middle gets starved of `#1` votes and _must flee the center_ to flank or leapfrog rivals. | **Highly vulnerable**:<br>• **Saboteur (`−A`)** shadows `A`'s hip, splitting `A`'s voter base so a less-popular rival `B` wins.<br>• **Kingmaker (`+A`)** crosses town and parks on rival `B`'s outer flank, splitting `B`'s vote so `A` wins effortlessly.                             | Plurality works for 2 candidates and breaks immediately at $3+$ candidates—rewarding polarization and clone/spoiler manipulation.                      |
| **IRV (Ranked Choice)** | Better than Plurality, **but** suffers from the **Center Squeeze**: when 3+ candidates crowd the middle, the centrist risks Round-1 elimination and is forced off-center to protect its `#1` base.                                                                      | **Still vulnerable via Round-1 elimination**:<br>• **Saboteur (`−A`)** can pinch centrist `A` so `A` is eliminated in Round 1 before `A`'s massive `#2` support is ever counted.<br>• **Kingmaker (`+A`)** can siphon Round-1 votes from a flanker so `A` survives to the final runoff. | IRV fixes simple fringe spoilers, but still punishes consensus centrists in competitive 3-way races (e.g., Burlington 2009, Alaska 2022).              |
| **Condorcet**           | **Pure centripetal convergence (Nash equilibrium)**: Moving closer to the center improves a candidate's 1-on-1 margin against _every_ rival simultaneously. All candidates rush the center and stay there.                                                              | **Spoiler & Mole Immunity**: Even if a Saboteur Mole parks right next to `A` and steals half of `A`'s `#1` votes, `A` still beats `B` and `C` head-to-head (`A > B`, `A > C`) and still wins!                                                                                           | Pairwise head-to-head comparison aligns candidate self-interest with the public good (moving toward the median voter) and neutralizes spoilers/clones. |

_(This is also why the UI method selector and results column are ordered
**`Plurality` $\to$ `IRV` $\to$ `Condorcet`**—so visitors experience the
progression from broken $\to$ flawed $\to$ spoiler-proof from left to right and
top to bottom.)_

---

## 2. How the Design & Engineering Evolved (4 Phases)

### Phase 1: Presets, Mole Roles & Live Spoiler Callout (`4e80f87`)

We added integrated simulation controls to
[`VoteTownWidget`](vote_demo/lib/src/widget/vote_town_widget.dart) and
[`BodyContent`](vote_demo/lib/src/widget/body_content.dart):

- **Story Presets
  ([`VoteTownPreset`](vote_simulation/lib/src/strategic_simulator.dart))**:
  1. `2 Candidates`: Baseline where Plurality, IRV, and Condorcet all agree.
  2. `3rd Spoils Plurality`: `A` is at the center `(75, 75)`, `B` is off to the
     right, and `C` enters on `A`'s left—flipping Plurality to `B` while IRV and
     Condorcet still elect `A`.
  3. `Center Squeeze (IRV)`: Canonical 3-candidate squeeze (`A=(75, 75)`,
     flanked by `B=(50, 75)` and `C=(100, 72)`) where at Turn 0 **every metric
     picks a different winner**: Voter Distance = `A` (`0.00`), Condorcet = `A`,
     Plurality = `C`, and IRV = `B` (`A` is eliminated first!).
- **Live Spoiler Alert Banner
  ([`detectPluralitySpoiler`](vote_simulation/lib/src/strategic_simulator.dart))**:
  Whenever the Plurality winner ($W_P$) differs from the Condorcet winner
  ($W_C$), a warning callout appears under the Plurality table showing the exact
  head-to-head margin ($W_C$ vs $W_P$). Hovering the banner triggers
  [`CandidateSetHoverNotification`](vote_widgets/lib/src/widget/vote_hover.dart)
  to show only $W_C$ and $W_P$ on the map, visually proving that $W_C$ crushes
  $W_P$ 1-on-1.

### Phase 2: From Stilted $10 \times 10$ Integer Grid to $15 \times 15$ Continuous 60fps Physics (`75806a6`)

After seeing the initial discrete grid in action, we observed why the $10 \times
10$ integer lattice felt stilted and hit local equilibria early:

1. **Coarse $19 \times 19$ Integer Lattice & 100 Voter-Dot "Holes"**: Candidates
   snapped in 5-unit jumps and couldn't cross even-even voter coordinates.
2. **Coarse $10 \times 10$ Vote Plateaus**: Moving slightly often flipped 0
   voters or an entire column of 10 voters at once.
3. **Even-Grid Center Deadlock**: An even number of rows/columns ($10 \times 10$
   or $16 \times 16$) puts the geometric center in an empty corridor between the
   middle two rows/columns, creating artificial `50%–50%` ties.

We upgraded the geometry and motion engine:

- **$15 \times 15 = 225$ Voters (Odd Grid)**: Gives $2.25\times$ finer Voronoi
  resolution _and_ an odd number of rows, columns, and voters with a true center
  voter at `(75, 75)`.
- **Continuous `Point<double>` Coordinates (`0..150`)**: Removed the integer
  lattice and voter-dot collision holes so candidates glide smoothly across the
  canvas.
- **60fps Velocity, Momentum & Quartic Repulsion
  ([`advancePhysicsFrame`](vote_simulation/lib/src/strategic_simulator.dart))**:
  Candidates steer toward their lookahead target with momentum (`0.80` damping),
  a steep quartic repulsion barrier (`0.35 * u + 3.2 * u^4`) inside
  `repulsionRadius`, and tangential velocity deflection so candidates bank and
  slide around each other instead of stalling head-on.

### Phase 3: Extracting Pure-Dart [`vote_simulation`](vote_simulation/) with `pkg:listen` (`b3e8773`)

To run fast, agent-driven simulations without booting Flutter, we audited the
dependency graph and extracted a standalone pure-Dart workspace package
[`vote_simulation`](vote_simulation/):

- Depends only on `collection`, `listen`, `meta`, and `vote` (zero
  `package:flutter` or `dart:ui` imports).
- Because Flutter's `foundation.dart` re-exports `ChangeNotifier` and
  `ValueListenable` from `package:listen`,
  [`VoteTownEditor`](vote_simulation/lib/src/vote_town_editor.dart) plugs
  directly into Flutter's `ChangeNotifierProvider` with zero adapter
  boilerplate.
- [`Candidate`](vote_simulation/lib/src/candidate.dart) stores pure-Dart `id`
  and `hue`, while [`vote_widgets`](vote_widgets/lib/src/model/candidate.dart)
  adds `CandidateColorExtension` (`color`, `darkColor`).
- Unlocked sub-second `dart test` runs and headless multi-turn simulation
  sweeps.

### Phase 4: Headless Agent Auditing & "Honest vs. Thumb-on-the-Scale" Tuning (`2b3b5aa`)

With [`vote_simulation`](vote_simulation/) running headlessly in pure Dart, we
ran 24-turn step sweeps and 600-frame continuous physics sweeps across every
preset, voting method, and Mole mode. That diagnostic exposed **5 root causes**
of weird behavior, which we separated into **3 purely honest bug fixes** and **2
deliberate modeling choices ("thumbs on the scale")**:

#### The 3 Purely Honest Fixes

1. **Fixing the Physics Repulsion Mismatch
   ([`town_folk.dart`](vote_simulation/lib/src/town_folk.dart),
   [`strategic_simulator.dart`](vote_simulation/lib/src/strategic_simulator.dart))**:
   - _What was broken_: `computeStrategicMove` allowed candidates to target
     spots `19.0` units from a neighbor, while `advancePhysicsFrame` pushed
     candidates apart at `29.0` units—and pushed stationary candidates just as
     hard as moving ones. Approaching challengers physically shoved stationary
     `A` off `(75, 75)`.
   - _Fix_: Aligned `repulsionRadius = 21.5` with `isLegalPoint` and scaled
     repulsion by a `mobilityFactor` (`(distToTarget / 5.0).clamp(0.0, 1.0)`) so
     stationary candidates sitting at their chosen target cannot be body-checked
     off their spot by moving challengers.
2. **Ranking by `[isSoleWinner, margin]` Instead of `[-myPlace.place, margin]`
   ([`strategic_simulator.dart`](vote_simulation/lib/src/strategic_simulator.dart))**:
   - _What was broken_: Putting `-myPlace.place` first meant a candidate
     preferred 2nd place losing by 40 votes (`[-2, -40]`) over 3rd place losing
     by 1 vote (`[-3, -1]`). Even worse, a Kingmaker Mole (`+A`) thought winning
     1st place itself was great because moving `A` from 3rd place to 2nd place
     (behind the Mole!) improved `-place(A)` from `-3` to `-2`.
   - _Fix_: Ranked candidate standing by `[isSoleWinner ? 1 : 0, margin, ...]`,
     and for `Mole Helps A` (`+A`) vs `Mole Hurts A` (`−A`), explicitly
     evaluated `-moleWinsElection`, `aMarginOverRivals`, and `stolenFromA`
     (voters taken from `A` compared to the town without the Mole).
3. **Canonical 3-Candidate `Center Squeeze (IRV)` Preset
   ([`strategic_simulator.dart`](vote_simulation/lib/src/strategic_simulator.dart))**:
   - _What was broken_: The preset had 4 candidates (`A` + 3 flankers
     `B, C, D`). In a 4-candidate setup, turning `D` into a Mole (`+A`) still
     left two independent selfish flankers (`B` and `C`) pinching `A` from
     opposite sides.
   - _Fix_: Updated `VoteTownPreset.irvCenterSqueeze` to the canonical
     3-candidate Left/Center/Right setup
     (`A=(75, 75), B=(50, 75), C=(100, 72)`).

#### The 2 Places With a Deliberate "Thumb on the Scale"

1. **"Satisficing Winner" Cushion (`margin >= 10` $\to$ Prefer Center)
   ([`strategic_simulator.dart`](vote_simulation/lib/src/strategic_simulator.dart))**:
   - _What it does_: Once a selfish candidate is the **sole winner** by a safe
     cushion (`>= 10` votes in Plurality/IRV, `>= 8` pairwise margin in
     Condorcet), its standing saturates so `centerBonus`
     (`-averageVoterDistanceTo`) keeps it anchored at `(75, 75)`.
   - _Why it's needed_: On a rectilinear $15 \times 15$ grid, a purely ruthless
     vote-maximizer at `(75, 75)` would step `3–5px` sideways off-center to
     `(75, 79)` because tilting the perpendicular bisector diagonally across a
     vertical column of 15 collinear voters flips 5 extra grid points (`120`
     $\to$ `125`). Treating a $\ge 10$-vote lead as "secure enough to stay at
     the median voter" removes rectilinear grid-tilt jitter while still forcing
     `A` out of `(75, 75)` the moment a spoiler or center-squeeze threatens its
     win.
2. **Mole Privileges (`Global Search` + `1.35x Speed/Reach` +
   `Vote-Siphon Heuristic`)
   ([`strategic_simulator.dart`](vote_simulation/lib/src/strategic_simulator.dart))**:
   - _What it does_: Selfish candidates search locally within `28px` and move at
     `1.0x` speed (`52 px/s`). The Mole (`+A` / `−A`) searches candidate flanks
     globally across the board, moves at `1.35x` speed (`70 px/s` / `37.8px`
     step), deflects around `A`'s personal space when crossing the board, and
     explicitly scores `aMarginOverRivals` and `stolenFromA`.
   - _Why it's needed_:
     - **Vision**: In `3rd Spoils Plurality`, Mole `C` starts on `A`'s left
       `(28, 48)` while rival `B` is on `A`'s right `(115, 75)`. With only
       `28px` local vision, `A(75, 75)` sits like a wall in the middle—stepping
       toward `B` initially steals _more_ votes from `A`, trapping a myopic Mole
       in the top-left corner.
     - **Speed (`1.35x`)**: Rival `B` orbits `A` on an **inside track** (~`22px`
       radius), while the Kingmaker Mole has to reach the **outside flank** of
       `B` (~`43px` radius). Because the outer circle has nearly $2\times$ the
       circumference of the inner circle, a Mole moving at `1.0x` speed on the
       outside track could never catch `B` on the inside track.

---

## 3. Verified Simulation Matrix (`Step` & `Continuous`)

| Preset                   | Method                      | Mode                            | Step-by-Step (24 turns)                                       | Continuous Play (600 frames)                            | What It Demonstrates                                                                                                                                                         |
| :----------------------- | :-------------------------- | :------------------------------ | :------------------------------------------------------------ | :------------------------------------------------------ | :--------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **2 Candidates**         | Plurality / IRV / Condorcet | All Selfish                     | `eq@6`: `P=[A] IRV=[A] C=[A]` (`A dist=0.00`)                 | `eq@115`: `P=[A] IRV=[A] C=[A]` (`A dist=0.00`)         | **Median Voter Theorem**: With 2 candidates, all methods agree and settle at the center.                                                                                     |
| **3rd Spoils Plurality** | Plurality                   | All Selfish                     | `active`: 3-way cycling (`P=[C]`, `SPOILER`)                  | `active`: 3-way cycling (`P=[C]`)                       | **Plurality Instability**: No pure-strategy Nash equilibrium with 3 selfish candidates; `A` is forced off center.                                                            |
| **3rd Spoils Plurality** | Plurality                   | Mole Helps A                    | `P=[A]` (`A:111 B:55 C:59`, `A dist=0.00`)                    | `P=[A]` (`A:87 B:66 C:72`, `A dist=0.00`)               | **Kingmaker Cloning**: Mole `C` crosses to `B`'s flank and splits `B`'s vote so `A` wins at `(75, 75)`.                                                                      |
| **3rd Spoils Plurality** | Plurality                   | Mole Hurts A                    | `P=[B]` (`A:53 B:113 C:59`, `B dist=0.00`)                    | `P=[B]` (`A:73 B:86 C:66`, `B dist=0.00`)               | **Vote Splitting**: Saboteur Mole `C` shadows `A`'s flank, handing Plurality to `B`.                                                                                         |
| **3rd Spoils Plurality** | IRV                         | Mole Helps A / Hurts A          | Helps: `IRV=[A]` (`A dist=0.00`) · Hurts: `IRV=[B]`           | Helps: `IRV=[A]` (`A dist=0.00`) · Hurts: `IRV=[B]`     | **IRV Vulnerability**: A strategic spoiler can still flip IRV by inducing or relieving a squeeze on `A`.                                                                     |
| **3rd Spoils Plurality** | Condorcet                   | All Selfish / Helps A / Hurts A | `eq@14 / eq@15 / eq@12`: **`C=[A]`** (`A dist=0.00`)          | `eq@141 / eq@179 / eq@128`: **`C=[A]`** (`A dist=0.00`) | **Condorcet Stability & Spoiler Immunity**: `A` never leaves `(75, 75)` and wins Condorcet even when `Mole Hurts A` reduces `A` to 31 first-choice votes (`P=[B], IRV=[B]`). |
| **Center Squeeze (IRV)** | IRV                         | All Selfish                     | `active`: `A` forced off `(75, 75)` on Turn 1 (`A dist=2.84`) | `active`: `A` forced off `(75, 75)` to survive Round 1  | **IRV Center Squeeze**: Because `A` is eliminated in Round 1 at `(75, 75)`, IRV forces the centrist to abandon the center.                                                   |
| **Center Squeeze (IRV)** | IRV                         | Mole Helps A / Hurts A          | Helps: `IRV=[A]` (`A dist=0.00`) · Hurts: `IRV=[B]`           | Helps: `IRV=[A]` (`A dist=0.00`) · Hurts: `IRV=[B]`     | Relieving vs. enforcing the squeeze flips IRV between `A` and `B`.                                                                                                           |
| **Center Squeeze (IRV)** | Condorcet                   | All Selfish / Helps A / Hurts A | `eq@8 / eq@20 / eq@20`: **`C=[A]`** (`A dist=0.00`)           | `eq@130 / eq@184 / eq@137`: **`C=[A]`** (`A dist=0.00`) | **Condorcet Resists Center Squeeze**: `A` stays at `(75, 75)` and wins head-to-head against both flankers.                                                                   |

---

## 4. Workspace Package Layout on `strategic-simulation`

- [`vote/`](vote/) — Core election algorithms (Plurality, Condorcet, IRV,
  Approval, Borda).
- [`vote_simulation/`](vote_simulation/) — Pure-Dart spatial voting & strategic
  physics engine (`15x15` continuous grid, selfish & Mole agents, presets,
  spoiler detection, `VoteTownEditor` via `package:listen`).
- [`vote_widgets/`](vote_widgets/) — Flutter result tables, hover notifications,
  and `CandidateColorExtension`.
- [`vote_demo/`](vote_demo/) — Flutter web app UI with `Plurality` $\to$ `IRV`
  $\to$ `Condorcet` ordering, preset buttons, Mole role badges (`+A` / `−A`),
  `Step` / `Play` controls, and the interactive Plurality Spoiler callout
  banner.
