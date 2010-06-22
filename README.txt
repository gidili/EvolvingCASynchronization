**Welcome to EvolvingCASynchronization**

This is Matlab code used for evolving Cellular Automata for the Majority Classification and Global Synchronization tasks with the Matlab GA tool (now part of the optimization toolkit). Most of the design choices were dictated by the fact that the code is supposed to be used with the Matlab GA toolkit, which forces you to have given inputs and output.

**Content of the repository**

- Common: a bunch of helper functions and classes, including a function to generate initial population for the GA
- MajorityClassification: fitness function for majority classification + ad-hoc code to visualize/evaluate rules
- GlobalSynchronization: same as majority classification but for the global synchronization task
- DiscoveryOfOscillatingClassifier: an old version of majority classification code that shows interesting results ...