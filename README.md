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

### Architecture 

TODO put this in another doc?  
TODO Explain the engine

The game is expressed in terms of **Instructions** and **Arbitrators**.

**Instructions** are a representation of how to mutate game state to convey a particular action; such as discarding a card, advancing a turn marker, and so on.

**Arbitrators** are consumers of user input (essentially an Instruction). An arbitrator decides if the provided input is valid given the current state of the game. If the input is valid, then the Instruction is executed within the context of the game, and the Arbitrator updates its internal state to reflect this. Arbitrators may arbitrate over several inputs before being satisfied.

As arbitrators exist in order to manage input, they serve a key role in controlling interaction with the game. Such roles include: enforcing the placement of influence within specified parameters (i.e. USSR to place 4 USSR influence in Eastern Europe); coups; realignments; etc.

Modifiers: Score, Permission

### Card Disposal

Card disposal is a more complex topic than it initially appears. 

When the card is played, it is set to the current card. This is useful for display purposes.

**Playing opponent card for event, then operations**. The event will execute and terminate with an instruction to discard, remove or limbo the card. This will occur, but the card will still be the current card. Discard/Remove/Limbo does not clear the current card attribute.

Operations is then played. No disposal event is triggered by operations.

The action round ends, and the `DisposeCurrentCard` instruction is fired. This will clear out the current card attribute, and attempt to discard the card. The Discard/Remove/Limbo instructions will not do anything if the card already exists in any of the three piles (it  is almost certain it will exist in one of the piles, given the event execution).

**Playing opponent card for operations, then event**. Swap the first two paragraphs in the preceding explanation.

**Playing own/neutral card for operations**. No disposal occurs as a result of operations. Disposal and therefore a discard, occurs at the end of the action round.

**Playing own/neutral card for event**. The event disposes of the card. The end-of-action-round disposal does no more than clear the current card attribute.

**Note:** the term 'discard' when applied to The China Card can be read as 'surrendered to the opponent' instead.

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
