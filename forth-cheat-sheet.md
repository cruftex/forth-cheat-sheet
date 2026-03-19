# Forth Cheat Sheet

Most relevant Forth words. **_@VERSION@_** Updates:
[cruftex.net/forth-cheat-sheet](https://cruftex.net/forth-cheat-sheet)

## Basic Syntax

- Forth is stack-based and uses postfix notation: `2 3 +`
- A program is a sequence of words or numbers separated by whitespace
- `\ comment` comments to end of line
- `( comment )` inline comment

## Stack Effects

Every word gets input from the stack and leaves results on the stack. How many and what type of elements are taken and left is documented in a stack effect in the form: `( before -- after )`.

Examples:

- `( a b -- a+b )`
- `( n -- n' )`
- `( -- )`

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
- `?dup` `( x -- 0 | x x )` (duplicates if non-zero)
- `2dup` `( x1 x2 -- x1 x2 x1 x2 )`
- `2drop` `( x1 x2 -- )`
- `2swap` `( x1 x2 y1 y2 -- y1 y2 x1 x2 )`
- `pick` `( xu .. x0 u -- xu .. x0 xu )`
- `roll` `( xu .. x0 u -- xu-1 .. x0 xu )`

Examples:

- `1 2 3 swap .s` output:  `<3> 1 3 2`
- `1 2 3 0 pick .s` output:  `<4> 1 2 3 3`

### Return stack

- `>r` `( x -- ) ( R: -- x )`
- `r>` `( -- x ) ( R: x -- )`
- `r@` `( -- x ) ( R: x -- x )`

The return stack can be used within an definition to keep data. 

## Literals and Booleans

- Numbers are written directly: `42`, `-7`
- `true` is `-1`
- `false` is `0`
- Any non-zero value is treated as true by conditionals

## Operators

### Arithmetic

<table>
  <tr><td><em>( a b -- result )</em></td><td><code>+</code> <code>-</code> <code>*</code> <code>/</code> <code>mod</code> <code>max</code> <code>min</code></td></tr>
  <tr><td><em>( u1 u2 -- u )</em></td><td><code>umin</code> <code>umax</code></td></tr>
  <tr><td><em>( u1 u2 -- ud )</em></td><td><code>um*</code></td></tr>
  <tr><td><em>( a b -- rem quot )</em></td><td><code>/mod</code></td></tr>
  <tr><td><em>( ud u1 -- rem quot )</em></td><td><code>um/mod</code></td></tr>
  <tr><td><em>( n -- n' )</em></td><td><code>1+</code> <code>1-</code> <code>negate</code> <code>abs</code></td></tr>
  <tr><td><em>( x -- x' )</em></td><td><code>2*</code> <code>2/</code></td></tr>
</table>

### Comparison

<table>
  <tr><td><em>( a b -- flag )</em></td><td><code>=</code> <code>&lt;&gt;</code> <code>&lt;</code> <code>&gt;</code> <code>&lt;=</code> <code>&gt;=</code></td></tr>
  <tr><td><em>( u1 u2 -- flag )</em></td><td><code>u&lt;</code> <code>u&gt;</code> <code>u&lt;=</code> <code>u&gt;=</code></td></tr>
  <tr><td><em>( x -- flag )</em></td><td><code>0=</code> <code>0&lt;&gt;</code> <code>0&lt;</code> <code>0&gt;</code></td></tr>
</table>

### Bit Twiddling

<table>
  <tr><td><em>( x y -- result )</em></td><td><code>and</code> <code>or</code> <code>xor</code></td></tr>
  <tr><td><em>( x u -- x' )</em></td><td><code>lshift</code> <code>rshift</code></td></tr>
  <tr><td><em>( x -- x' )</em></td><td><code>invert</code></td></tr>
</table>

## Memory fetch/store

- `@` `( addr -- x )` fetch cell
- `!` `( x addr -- )` store cell
- `c@` `( addr -- c )` fetch byte
- `c!` `( c addr -- )` store byte
- `+!` `( n addr -- )` add to cell in memory

## Address arithmetic

- `cells` converts cell counts to address offsets
- `cell+` adjusts address to next cell

## Defining Variables and Constants

- `variable <name>` reserves space for one cell and create a word returning the address
- `constant <name>` creates a named value
- `value n` creates a mutable named value
- `to` updates a `value`

Examples:

```forth
variable counter
10 counter !
counter @ .

42 constant answer
answer .

5 value step
step .
7 to step
step .
```

## Reserving arbirary Space

A forth writes the program and data into a data space called _dictionary_.

- _( -- addr )_ `here` address of the next free byte in dictionary
- `create <name>` create a word returning an address into the dictionary. Space can be reserved with the next words
- _( n -- )_ `allot` reserves bytes dictionary space
- `n ,` reserve space for one cell and store the value
- `n c,` reserve space for one character and store the value

Examples:

```forth
\ identical to variable count, not initialised
create counter 1 cells allot

\ same, but initilised with 0
create counter 0 ,
```

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
- `." hello"` prints a string during defenition execution
- `s" hello"` `( -- addr len )` puts string on stack
- `count` `( c-addr1 -- c-addr2 u )` counted string to address and length
- `move` `( addr1 addr2 u -- )` copy `u` bytes
- `place` `( addr u c-addr -- )` store as counted string

Examples:

```forth
123 .
cr
s" hello" type cr
```

## Input

- `key` `( -- c )` read one character
- `key?` `( -- f )` true if input is available

## Conditional execution

Conditionals can only be used within a definition.

- `( f ) if ... then`
- `( f ) if ... else ... then`

Example:

```forth
: my-abs ( n -- u )
  dup 0< if negate then ;
```

## Looping

Loops can only be used within a definition.

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
- `-3` / `-4` stack overflow / underflow
- `-5` / `-6`  return stack overflow / underflow
- `-9` invalid memory address
- `-10` division by zero
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
