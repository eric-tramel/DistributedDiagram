DistributedDiagram
==================

A Matlab Package for Multiplayer Phase Diagrams ! 

Introduction
------------
The basic premise of this package is to facilitate the calculation of 
two-dimensional diagrams across multiple parties/systems/machines within
Matlab. The goal is to give a tool to aid researchers working on signal
processing problems which require the detection of "Phase Diagrams" 
across a space of two experimental parameters.

Basic Approach
--------------
For a given pre-written DD-Test-Module, each party will run an
experiment at a random point in the diagram space, as determined by
a given DD-Point-Generation-Module. Because of the random nature of
the point selection, experiments can be started or stopped at will 
by each party. The local results files from each party can then 
be collected and appended to generate the full list of results. 
Finally, these point-results are then interpolated over the 
experiment space.

Usage
-----
First, DistributedDiagram and the user's experimental code must be on 
the current Matlab path. Next, DistributedDiagram can either be started
using the `interactive_dd.m` script, or can be called directly through
`run_dd`. The number of tests to run, the output file name, and two anonymous
functions must be specified: The point generation module and the experimental module.
The user-written experimental module must take two inputs and return all results as
a vector of numeric values.


