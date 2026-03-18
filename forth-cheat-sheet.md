# Forth Cheat Sheet

Most relevant forth words. Compact, `gforth` / `ec4th` friendly. (C) cruftex.

## Reading Stack Effects

Stack effects use `( before -- after )`.

Examples:

- `( a b -- a+b )`
- `( n -- n' )`
- `( -- )`

## Basic Syntax

- Forth is stack-based and uses reverse polish notation: `2 3 +`
- A word is a command/name separated by whitespace
- `\ comment` comments to end of line
- `( comment )` inline comment

## Defining Words

- `: name ... ;` defines a word
- `exit` returns early from a word
- `recurse` calls the current word recursively

Examples:

```forth
: square ( n -- n2 ) dup * ;
: cube ( n -- n3 ) dup dup * * ;
```

## Data Stack Manipulation

- `dup` `( x -- x x )`
- `drop` `( x -- )`
- `swap` `( x y -- y x )`
- `over` `( x y -- x y x )`
- `rot` `( x y z -- y z x )`
- `-rot` `( x y z -- z x y )`
- `nip` `( x y -- y )`
- `tuck` `( x y -- y x y )`
- `pick` `( xu .. x0 u -- xu .. x0 xu )`
- `roll` `( xu .. x0 u -- xu-1 .. x0 xu )`
- `?dup` `( x -- 0 | x x )` duplicates only if non-zero

Example:

```forth
\ stack: 10 20 30
2 pick   \ 10 20 30 10
2 roll   \ 20 30 10
```

### Return stack

- `>r` `( x -- ) ( R: -- x )`
- `r>` `( -- x ) ( R: x -- )`
- `r@` `( -- x ) ( R: x -- x )`

The return stack can be used within an definition to keep data. 

## Literals and Booleans

- Numbers are written directly: `42`, `-7`
- `true` is `-1`
- `false` is `0`
- Any non-zero value is treated as true by control words

## Binary Operators

Words taking two operands from the stack.

### Arithmetic

_( a b -- result )_ `+` `-` `*` `/` `mod` `max` `min`

_( u1 u2 -- u )_ `umin` `umax`

_( u1 u2 -- ud )_ `um*`

_( a b -- rem quot )_ `/mod`

_( ud u1 -- rem quot )_ `um/mod`

### Comparison

_( a b -- flag )_ `=` `<>` `<` `>` `<=` `>=`

_( u1 u2 -- flag )_ `u<` `u>` `u<=` `u>=`

### Bit Twiddling

_( x y -- result )_ `and` `or` `xor`

_( x u -- x' )_ `lshift` `rshift`

## Unary Operators

Words taking one operand from the stack.

### Arithmetic

_( n -- n' )_ `1+` `1-` `negate` `abs`

_( x -- x' )_ `2*` `2/`

### Comparison

_( x -- flag )_ `0=` `0<>` `0<` `0>`

### Bit Twiddling

_( x -- x' )_ `invert`

## Memory

### Addresses and fetch/store

- `@` `( addr -- x )` fetch cell
- `!` `( x addr -- )` store cell
- `c@` `( addr -- c )` fetch byte
- `c!` `( c addr -- )` store byte
- `+!` `( n addr -- )` add to cell in memory

### Variables and constants

- `variable x` reserves space for one cell
- `constant n` creates a named value
- `value n` creates a mutable named value
- `to` updates a `value`

Examples:

```forth
variable count
10 count !
count @ .

42 constant answer
answer .

5 value step
step .
7 to step
step .
```

### Address arithmetic

- `cells` converts cell counts to address offsets
- `chars` converts char counts to address offsets
- `cell+`
- `char+`
- `allot` reserves dictionary space

## Number output

- `.` prints top stack item
- `.s` prints stack contents without consuming them
- `hex` switch to hexadecimal output
- `decimal` switch to decimal output
- _( n -- )_ `base !` switch number output and input to arbirary base
- _( -- n )_ `base @` get base in effect

## Output and Strings

- `emit` prints one character
- `cr` newline
- `space` print a space
- `type` `( addr len -- )` prints a string
- `." hello"` prints a string during execution of a definition
- `s" hello"` `( -- addr len )` pushes string address and length

Examples:

```forth
123 .
cr
s" hello" type cr
```

## Conditional execution

- `( f ) if ... then`
- `( f ) if ... else ... then`

Example:

```forth
: my-abs ( n -- u )
  dup 0< if negate then ;
```

## Looping

- `begin ... again`
- `begin ... ( f ) until`
- `begin ... ( f ) while ... repeat`
- `( end+1 start ) do ... loop`
- `( end+1 start ) ?do ... loop` for possibly skipped loops
- `( end+1 start ) do ... +loop`
- `leave` exits a `do` loop early
- `i` current loop index
- `j` next outer loop index

Examples:

```forth
: countdown ( n -- )
  begin dup . 1- dup 0< until drop ;

: stars ( n -- )
  0 do [char] * emit loop cr ;
```

## Debugging

- `words` prints available words
- `.s` print stack contents without altering it
- `.sh` print stack contents in hex without altering it (ec4th)
- _( addr len -- )_ `dump` dump memory contents at address (gforth/ec4th)

## Error codes

- `-1` `abort`
- `-2` `abort"` / error with aditional message
- `-3` stack overflow
- `-4` stack underflow
- `-5` return stack overflow
- `-6` return stack underflow
- `-9` invalid memory address
- `-10` division by zero
- `-11` result out of range
- `-12` argument type mismatch
- `-13` undefined word
- `-14` interpreting a compile-only word
- `-22` control structure mismatch
- `-25` return stack imbalance
- `-28` user interrupt

## Compilation vs Interpretation

- In interpret state, words execute immediately
- Some words are only allowed inside a definition, that is called compile only
- Inside `: ... ;`, most words compile instead of execute
- `[` switches to interpret state during compilation
- `]` switches back to compile state
- `literal` compiles a stack value as a literal
- `' name` gets execution token of `name`
- `execute` runs an execution token
