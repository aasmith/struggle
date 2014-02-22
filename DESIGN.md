# Architecture

TODO DOC Explain the engine

The game is expressed in terms of **Instructions** and **Arbitrators**.

**Instructions** are a representation of how to mutate game state to convey
a particular action; such as discarding a card, advancing a turn marker,
and so on.

**Arbitrators** are consumers of user input (essentially an Instruction).
An arbitrator decides if the provided input is valid given the current
state of the game. If the input is valid, then the Instruction is executed
within the context of the game, and the Arbitrator updates its internal
state to reflect this. Arbitrators may arbitrate over several inputs before
being satisfied.

As arbitrators exist in order to manage input, they serve a key role in
controlling interaction with the game. Such roles include: enforcing the
placement of influence within specified parameters (i.e.  USSR to place 4
USSR influence in Eastern Europe); coups; realignments; etc.

TODO DOC Modifiers/Observers: Stack, Permission

## Card Disposal

Card disposal is a more complex topic than it initially appears.

When the card is played, it is set to the current card. This is useful for
display purposes.

**Playing opponent card for event, then operations**. The event will execute
and terminate with an instruction to discard, remove or limbo the card.
This will occur, but the card will still be the current card.
Discard/Remove/Limbo does not clear the current card attribute.

Operations is then played. No disposal event is triggered by operations.

The action round ends, and the `DisposeCurrentCard` instruction is fired.
This will clear out the current card attribute, and attempt to discard the
card.  The Discard/Remove/Limbo instructions will not do anything if the
card already exists in any of the three piles (it is almost certain it
will exist in one of the piles, given the event execution).

**Playing opponent card for operations, then event**. Swap the first two
paragraphs in the preceding explanation.

**Playing own/neutral card for operations**. No disposal occurs as a result
of operations. Disposal and therefore a discard, occurs at the end of the
action round.

**Playing own/neutral card for event**. The event disposes of the card.
The end-of-action-round disposal does no more than clear the current card
attribute.

**Note:** the term 'discard' when applied to The China Card can be read
as 'surrendered to the opponent' instead.

## Resolution of Points

There are two types of numeric value resolution in Twilight Struggle.

One involves evaluating the **operation points** value of a given card.
This affects the card for **all operations**; be it determining entry
requirements for space race, military ops for coups, placement of influence,
etc.

The other resolution involves determining the final total of a die roll.
Its targeting is applied by player, operation type and geography.

Modifiers can be cumulative.

## Operation Points

Types of events that change operation points:

#### Unconditional: +1/-1 to a maximum/minimum amount

 * Red Scare/Purge
 * Containment
 * Brezhnev Doctrine

#### Conditional: +1 when all points are spent in a particular location

 * Vietnam Revolts
 * China Card

#### Order of resolution

When multiple modifiers are in effect, order of resolution is also important.
Consider the USSR player playing a 1 op card for operations in SE Asia.
Red Scare and Vietnam Revolts have both been played for event, and both
apply to the USSR player:

 - USSR Plays 1 op card
 - Red Scare deducts -1 to a min of 1. Thus, no effect.
 - Vietnam Revolts adds +1 with no limits.

This leads to an incorrect resolution of **2** (1 + 0 + 1).

Cards should resolve thusly:

 - USSR plays 1 op card
 - Vietnam Revolts adds +1 with no limits.
 - Red Scare deducts -1 to a min of 1.

This leads to a correct resolution of **1** (1 + 1 - 1).

Other end of scale 4 + 1(max:4) - 1(min:1) + 1

#### Example from rules, Section 7.4

Some event cards modify the Operations value of cards that follow.  These
modifiers should be applied in aggregate, and can modify ‘The China Card’.

> EXAMPLE: The US player plays the Red Scare/Purge event during the Headline
Phase. Ordinarily, all USSR cards would subtract one from their Operations
value. However, for his Headline card, the USSR played Vietnam Revolts.
This event gives the Soviet player +1 to all operations played in SE Asia.
For his first play, the USSR chooses ‘The China Card’. He plays all points
in SE Asia for 5 operations points.  This is modified by the Vietnam Revolts
card, giving the USSR player 6 operation points.  However, the US Red
Scare/Purge card brings the total down to 5 operations points.

#### Implementation

See `OpsCounter` and `OpsModifier` and their test cases.


## Changing the Value of a Die Roll

#### Realignments

 * **Iran-Contra Scandal**

#### Coups

 * **SALT Negotiations** changes the value of the die roll only.  Military
 Ops are not affected.
 * **Latin American Death Squads** changes the value of the die roll only
 (see Ruling #4). Military Ops are not affected.

#### Implementation

Generate a die roll using `Die#roll`. Modify the roll by summing all
`amount` values on the applicable die roll modifiers in place (call
`Observers#die_roll_modifiers`).

It is currently unknown if there is a lower limit that a die roll can be
modified down to. If there is one, then the resolution of modifiers will
need more active management rather than just summing all modifiers.

## TODO

### Unaddressed Items

 * **A human-readable log mechanism**: makes every action taken by the
 game presentable to the player. Should leave no ambiguities about the
 order of play and the reasons for certain outcomes (such as a decreased
 ops value of card, etc.)

 * **Re-evaluate the need for `Move`**: The `Move` class encapsulates a
 player's input into the game engine. This always wraps an instruction,
 and only adds a player attribute. This typically adds an extra level of
 indirection that makes dealing with moves somewhat cumbersome. The `Move`
 class could be removed in favour of the player providing `Instruction`
 objects directly.
