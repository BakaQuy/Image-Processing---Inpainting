********************
File:	 readme.txt
Author:	 Simon Korman
Date:	 18.11.2014
Version: 3.0
********************

Minimum requirements:
====================
1. Matlab 2008 or later.
2. C/CPP compiler installed properly for mex compiling.


Way to go:
==========
To install and run the CSH algorithm, please use the following instructions:
1. run AddPaths.
2. run compile_mex.
3. CSH_nn is the CSH algorithm entry point function. You can type help CSH_nn to get a short description on 
   the function as well as the input/output parameters
4. You can use CSH_nn_example_usage.m script to run several examples or call the CSH algorithm using the CSH_nn function.

Have fun!

Simon



Version Control
===============

VERSION 1.0 - 24.10.2011 (first version)
----------------------------------------

VERSION 2.0 - 30.4.2012 (first version)
----------------------------------------
1. Bug Fixes
2. Updated examples file

VERSION 3.0 - 18.11.2014 (current version)
----------------------------------------
1. Bug Fixes
2. Updated examples file:
	- More visualization
    - Added a 'fast' KNN for large Ks (based on 'social'-CSH)
	- Showing also reconstruction (of image A from image B and mapping A=>B) on the first example (using Patch-Match code for it)

