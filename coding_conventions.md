# Coding Convetions

This briefly summarizes the main coding conventions followed in this project.


Overall purpose of these: Make code very readable!
Think of: Can someone who understands PTB looking at *any* few lines of your code understand what is going on?
Ideally: picking any consecutive 5 lines of code, it is possible to understand what is going on at that place.

# General:
* write more comments than you think are necessary (future-you will thank you)
* code should never be wider than 80 characters (see Editor preferences to put your line there)
* write comments before the relevant line, esp. to stay within 80 character limit
* use indentation (at least Matlabs "smart indent")
* rule-of-thumb: set parameters strings (e.g. folder paths) in main script, use variables inside sub-functions

# Code structuring
Or, when to use separate functions, scripts, etc.?

* use cells (`%% cell-name` comment lines) to chunk your code
* chunk code into separate functions as much as possible - based on logical units/convenience (e.g. Initialize)
* for functions which will be used in time-critical parts of the code, try to call them with dummy input prior to getting into time-critical part. [Matlab will compile and optimize your code at the first-call of the function. Thus, the first use takes longer than the subsequent ones]
* restructure your code so that you do not have almost the same code in multiple places (i.e. no copy/pasting). BUT: think also of readability (in a few months!)

* the actual task (stimulus presentation for participants) should not perform any randomization, etc.; instead, load trails structure from disk.
* if you task run is "long", structure code such that you can re-start "in the middle" of the run. Beware: you need to think carefully what that does psychologically to the participant.
* if you have multiple tasks (e.g. some calibration and a task of interest) which you call in one go, split them up into separate functions
* wrap your task-script (the "outer most") into a `function()` so that matlab can optimize the speed
* make your task use variables

# saving results
* if you choose to save responses at each trial iteration, assert that writing to disk is not slowing down PTB too much and leading to missed screen-flips.
* if it does not slow down too much, it is preferable to saving only at the end (or at block-boundaries).
* format: end goal is to have BIDS-compatible logs. You can either save to `.mat` files and provide a converter function, or directly store everything in BIDS format.


# Variable names
* starts with small letter
* uses CamelCase
* try to avoid "single letter" variable names -- use meaningful names
* for loops (iterators), use "iTrail", "iBlock", etc., i.e. start with "i" and then add a meaningful word
* preallocate arrays (or: `for i=N:-1:1`)
* for matrices, you can use Matlab's convention of single capital letter, if the meaning is established outside of your task (e.g. GLM's design matrix X)

## When to use struct()
* to group a set of variables which logically belong together. For example:
** machine related variables: screen-size, windowPointer, which keyboard/mouse device you are using [might change if switching stimulus PC]
** task-related parameters: nr of trials, conditions, colors for stimuli, etc. [will not change when switching stimulus PC, but only if doing different version of task]
* struct-names: use **very** short names (e.g. `P` for parameters) and add comment describing what that struct will contain when you creating it.
** use capital letter instead

# Functions
* starts with capital letter
* uses CamelCase
* passing structs as input argument: if your function is using 5 or fewer of the struct's fields, pass them as individual input arguments.
** For time-critical functions, do *not* "copy out" the individual fields of the struct (e.g. `screenSize = P.screenSize;`)
** For non-time-critical function, *do* copy out fields.
* mandatory: write a "help" section for each function
* For organizing sets of functions (e.g. preparing a task, running a task, and post-processing a task), use underscores in names as appropriate

# code optimization
try to optimize your MAtlab code as much as possible for the time-critical parts. (do not over-do it for the other parts..)
Google is your friend :)

A few examples:
* https://www.eetimes.com/document.asp?doc_id=1275446&page_number=1
* if you can avoid `repmat()` by using arithmetic expression, do so (i.e. ones() * 3)
