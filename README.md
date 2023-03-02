# TECHNOLOGY OVERLOAD
Vanilla Factorio is too easy for you? Try the Fibonacci research cost! Take on the new challenges of Technology Overload, new ways to increase game difficulty! Technology cost tweaked in different ways to introduce new challenges and spice up you tech tree. Not the regular multiplier, plenty of modes to choose, Fibonacci research cost and much mode in the game settings!

---

## Main Features
Here's the description of what each game mode consist of as well as a general ranking of the difficulty out of 10 points. 

Game modes:

- [1/10] None, plain vanilla tech cost
- [2/10] Funnel (slow start, fast endgame)
- [11/10] Miserable Spoon (Funnel^2 * 10)
- [7/10] Fibonacci (cumulative)
- [3/10] Spiral (X * N, N=depth, Ct=1)
- [7/10] Mad Spiral (Fibonacci * N, N=depth)
- [4-7/10] Tree (X * N * Ct, N=depth, Ct=2, 3, 4, ...)
- [9/10] Mad Tree (Fibonacci * N * Ct, N=depth, Ct=2, 3, 4, ...)
- [6/10] A Long Way Home (X * N^2, N=depth)

![](https://assets-mod.factorio.com/assets/d27abd22592c98c91f68f8cbf5909d6a9d9bae11.png)

---

### Funnel
Slow in, fast out! Just as racing drivers slowly approach the apex of the corner to get a better exit, so our engineer, landed ona a new planet, takes some time to adapt to the new world but slowly progresses and gets up to speed. The technology cost is higher at the start (~x20) but gets to x1 by the infinite technologies.
Note, the initial multiplier is based on the tech tree depth. If your tech tree has 20 levels of technologies at most, that will be the initial multiplier (vanilla). On larger modpacks, if your tech tree has more levels, the initial multiplier will increase accordingly.

### Miserable Spoon
Just like Funnel mode, but on steroids. In this mode, the initial multiplier is the ^2 of Funnel, and x10! Will you be able to get out of the mud in time before biters get you??? 
Note, the multiplier works similar to the Funnel mode, so higher values are expected for larger modpacks.

### Fibonacci
This is the default mode and the coolest one. Technology costs scales similar to the [Fibonacci sequence](https://www.mathsisfun.com/numbers/fibonacci-sequence.html). Each technology has its own cost tweaked to be equal to its original cost plus all the cumulative cost you've spent to get to that research! Have fun!
If you're not familiar with Fibonacci I'd recommend to check out the link above.

### Spiral and Tree
In Spiral and Tree mode, as you progress deeper into the tech tree, the research costs gets multiplied by that depth level (e.g. first research is x1, 8th is x8, 15th is x15...), there are multiple trees in the tech tree and each branch gets multiplied by its own depth, it does not depend on the order you choose to research. Tree mode is similar to Spiral mode, but the depth gets multiplied by an additional TreeCoefficient of your choice, default is 2.

### Mad Spiral and Mad Tree
Similar to Spiral and Tree mode, in Mad mode instead of considering the technology's cost, the Fibonacci sequence up to that point 8or cumulative cost) is considered and multiplied by the depth, as well as by the TreeCoefficient if you select Mad Tree mode. These are two of the hardest modes of this mod.

### A long Way Home
In this mode, as you progress deeper into the tech tree, the research cost is increased by the square power of that technology's depth! This is the hardest mode, following an exponential growth it will test your patience and abilities. It's a long way home...

---

## Goals
If any of you manages to 100% the tech tree on one of the HARD/HARD++ modes (or any of the other ones), please post your time on the Discussion page of this mod if you want, I'll be very interested, thanks! :)

---

## Image Explanation
I've run a small demo of how research costs work. Please note, these calculation are a rough estimate of the in-game values as I used a smaller and incomplete dataset to run the demo. Cumulative costs are expected to be much higher.

Fig.(1) - Prevision of each technology's Cost. hard to read, A-Long-Way-Home outshines other values)
Fig.(2) - Prevision of each technology's Logaritmic Cost (base 10), easier to read
Fig.(3) - Prevision of each technology's Cost without the hardest game modes in order to compare it to vanilla
Fig.(4) - Prevision of each technology's Logaritmic Cost without the hardest game modes in order to compare it to vanilla
Fig.(5) - Table of values used in the demo (in-game values and modded maps are expected to have higher values)

---

## Known Bugs and Mod compatibility

*Technology Overload* should be compatible to all mods and can be added to ongoing saves. However, compatibility has been improved for special circumstances with the following mods:

- pY modpack (value are capped at 10^12 due to overflow issues)

It's a new mod, if you encounter any issue or have particular requests for other game modes, please refer to the Discussion page of this mod, thanks!
