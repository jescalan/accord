CSSO
====

Csso is a great tool for optimizing css. It's public API is very simple, sometimes to a fault, where it becomes difficult to track down errors. Although we're considering building in some extra error tracking in the future, for now just be careful. The adapter only takes one option, `no_restructure`, which if set to true disables structure minimization (which means that if any selector appears twice, they are merged together)/
