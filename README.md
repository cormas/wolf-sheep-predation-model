# Wolf Sheep Predation

Wolves eat sheep, sheep eat grass, and both reproduce. Depending on the rules, the two populations oscillate, or one of them goes extinct.

This is the predator-prey model of Wilensky and Reisman, in the three versions they published:

1. **Wolves and sheep** (`sheepWolves`): sheep never run out of food. Unstable: one species goes extinct.
2. **Wolves, sheep and grass** (`sheepWolvesGrass`): sheep eat grass, which grows again after some time. Both species survive.
3. **Crowding** (`sheepWolvesCrowding`): as version 1, but sheep only move to and give birth on unoccupied patches. Unstable.

Each version has its own init method and its own control method (`stepSheepWolves`, `stepSheepWolvesGrass`, `stepSheepWolvesCrowding`).

## Source

Wilensky, U. & Reisman, K. (2006). Thinking like a wolf, a sheep or a firefly: Learning biology through constructing and testing computational theories — an embodied modeling approach. *Cognition and Instruction*, 24(2), 171–209.

The paper is the reference for the rules. Where it says nothing (the values of the parameters, the size of the world, the energy of animals at the start, how a parent shares its energy with its offspring, the grass at the start), this model follows the [NetLogo Wolf Sheep Predation model](https://ccl.northwestern.edu/netlogo/models/WolfSheepPredation) (Wilensky, 1997).

## Differences with NetLogo's model

- Animals move to a random adjacent patch at each step, as the paper says, where NetLogo's turn a little and move forward. They spread more slowly, so in version 2 the wolves stay fewer and the populations oscillate less than in NetLogo.
- Wolves die when their energy reaches 0, and moving has its own energy cost, as in the paper.
- A patch grows grass again exactly `grassRegrowthTime` steps after it was eaten, as in the paper.
- NetLogo's switch that shows each animal's energy as a number has no equivalent: Cormas cannot write text on entities yet.
