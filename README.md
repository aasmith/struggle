## Twilight Struggle
#### *The Cold War, 1946—1989*

An attempt to create a faithful clone of the board game Twilight Struggle.

http://github.com/aasmith/struggle

### Synopsis

```struggle``` aims to be a rules-enforced version of the board game Twilight Struggle. It has three logical parts:

 1. The representation of the game, encompassing all state needed to represent an active game, as well as a rules engine to enforce rules and inputs
 2. A CLI or other basic input/output system for playing a game locally
 3. A web API and UI for allowing play over networks

### Current Status

Current development is focused on getting the game engine to a playable state. 

Also see DESIGN.md.

### Requirements

Ruby 2.1 or higher.

### Install

Clone the project from github:

```git clone git://github.com/aasmith/struggle```

No interactive version exists yet, an example of a game exists in ```bin/struggle```.

### Developers

After checking out the source, run:

```$ rake newb```

This task will install any missing dependencies, run the tests/specs,
and generate the RDoc.

### License

##### Copyright (c) 2014 Andrew A. Smith <andy@tinnedfruit.org>

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
