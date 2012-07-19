# vote.dart
## Code to simulate, run, and calculate elections with different election methods

<img src="https://github.com/kevmoo/vote.dart/raw/master/vote_dart_preview.png" width='750'>

## The Simulation

> Imagine a city with population of 400 voters (small circles) evenly distributed into blocks--20 by 20.

> The city is trying to decide where to put the post office. Candidate locations are represented by the lettered circles on the map.

> __Distance:__ An easy--although undemocratic--way to choose the best location is simply to calculate the average distance from each voter to each candidate. The candidate with the lowest average distance is the best option.

> __Plurality:__ The most obvious democratic method to choose a location is to let voters **vote**. Each voter will make the obvious choice and vote for the candidate location that is closest. The color of each voter reflects the closest candidate.

## Authors
 * [Kevin Moore](https://github.com/kevmoo) ([@kevmoo](http://twitter.com/kevmoo))

## Dependencies
 * __vote.dart__ assumes the contents of [dartlib](https://github.com/kevmoo/dartlib) are in an adjacent directory named `dartlib`.
     * _Once [pub](http://www.dartlang.org/docs/pub-package-manager/) is stable, __dartlib__ will be a registered dependency._

## More Info
 * [Condorcet Method](http://en.wikipedia.org/wiki/Condorcet_method) - Wikipedia

## [The BSD 2-Clause License](http://www.opensource.org/licenses/bsd-license.php)

    Copyright (c) 2012, vote.dart project authors
    All rights reserved.

    Redistribution and use in source and binary forms, with or without
    modification, are permitted provided that the following conditions are met:

    1. Redistributions of source code must retain the above copyright notice, this
       list of conditions and the following disclaimer.
    2. Redistributions in binary form must reproduce the above copyright notice,
       this list of conditions and the following disclaimer in the documentation
       and/or other materials provided with the distribution.

    THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
    ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
    WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
    DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
    ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
    (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
    LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
    ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
    (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
    SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

    The views and conclusions contained in the software and documentation are those
    of the authors and should not be interpreted as representing official policies,
    either expressed or implied, of the FreeBSD Project.
