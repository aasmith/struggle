## Architecture

TODO Explain the engine

The game is expressed in terms of **Instructions** and **Arbitrators**.

**Instructions** are a representation of how to mutate game state to
convey a particular action; such as discarding a card, advancing a turn
marker, and so on.

**Arbitrators** are consumers of user input (essentially an
Instruction). An arbitrator decides if the provided input is valid given
the current state of the game. If the input is valid, then the
Instruction is executed within the context of the game, and the
Arbitrator updates its internal state to reflect this. Arbitrators may
arbitrate over several inputs before being satisfied.

As arbitrators exist in order to manage input, they serve a key role in
controlling interaction with the game. Such roles include: enforcing the
placement of influence within specified parameters (i.e. USSR to place 4
USSR influence in Eastern Europe); coups; realignments; etc.

TODO Modifiers: Stack, Score, Permission

### Card Disposal

Card disposal is a more complex topic than it initially appears.

When the card is played, it is set to the current card. This is useful
for display purposes.

**Playing opponent card for event, then operations**. The event will
execute and terminate with an instruction to discard, remove or limbo
the card. This will occur, but the card will still be the current card.
Discard/Remove/Limbo does not clear the current card attribute.

Operations is then played. No disposal event is triggered by operations.

The action round ends, and the `DisposeCurrentCard` instruction is
fired. This will clear out the current card attribute, and attempt to
discard the card. The Discard/Remove/Limbo instructions will not do
anything if the card already exists in any of the three piles (it  is
almost certain it will exist in one of the piles, given the event
execution).

**Playing opponent card for operations, then event**. Swap the first two
paragraphs in the preceding explanation.

**Playing own/neutral card for operations**. No disposal occurs as a
result of operations. Disposal and therefore a discard, occurs at the
end of the action round.

**Playing own/neutral card for event**. The event disposes of the card.
The end-of-action-round disposal does no more than clear the current
card attribute.

**Note:** the term 'discard' when applied to The China Card can be read
as 'surrendered to the opponent' instead.

## TODO

### Outstanding Items

A list of items that the game needs, and exist in either design or are
present in the game in a stubbed form:

 * **ScoreModifier**: a centralised resource for determining the ops
 value of a card after evaluating all rulings in effect.

### Unaddressed Items

These are needed but currently are not designed, implemented, stubbed or
hooked into the game in any way:

 * **A human-readable log mechanism**: makes every action taken by the
 game presentable to the player. Should leave no ambiguities about the
 order of play and the reasons for certain outcomes (such as a decreased
 ops value of card, etc.)
