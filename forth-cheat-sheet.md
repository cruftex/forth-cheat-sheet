# Forth Cheat Sheet

Most relevant Forth words. **_@VERSION@_** <br>
(CC BY-SA) 2026 Jens Wilke / cruftex / DJ8CE

## Basic Syntax

- Forth is stack-based and uses postfix notation, meaning that the operator is placed after the operands: `2 3 +`
- A program is a sequence of words or numbers separated by whitespace. The sequence is executed in the order the words or numbers appear
- `\ comment` comments to end of line
- `( comment )` inline comment

Examples:

```forth
2 3 + .
\ comment for the whole line
```

Looking at the sequence `2 3 + .` the following happens step by step:

- `2` — put the number `1` on the stack
- `3` — put the number `3` on the stack
- `+` — adds the top two numbers on the stack and returns the result on the
stack
- `.` — print the top of stack

## Stack Effects

Every word gets input from the stack and leaves results on the stack. How many and what type of elements are taken and left is documented in a stack effect in the form: `( before -- after )`.

Examples:

`( a b -- a+b )`<br>
`( n -- n' )`<br>
`( -- )`

## Defining Words

`: name ... ;` — defines a word<br>
`exit` — returns early from a word<br>
`recurse` — calls the current word recursively

Examples:

```forth
: square ( n -- n2 ) dup * ;
: cube ( n -- n3 ) dup dup * * ;
: percent ( part whole -- pct )
  swap 100 * swap / ;
```

## Data Stack Manipulation

As we saw in the `percent` example above, sometimes the operands are not on
the correct position in the stack. Here is a list of common forth words that
manipulate the stack:

`dup` `( x -- x x )`<br>
`drop` `( x -- )`<br>
`swap` `( x y -- y x )`<br>
`over` `( x y -- x y x )`<br>
`rot` `( x y z -- y z x )`<br>
`-rot` `( x y z -- z x y )`<br>
`nip` `( x y -- y )`<br>
`tuck` `( x y -- y x y )`<br>
`?dup` `( x -- 0 | x x )` — duplicates if non-zero<br>
`2dup` `( x1 x2 -- x1 x2 x1 x2 )`<br>
`2drop` `( x1 x2 -- )`<br>
`2swap` `( x1 x2 y1 y2 -- y1 y2 x1 x2 )`<br>
`pick` `( xu .. x0 u -- xu .. x0 xu )`<br>
`roll` `( xu .. x0 u -- xu-1 .. x0 xu )`

Examples:

`1 2 3 swap .s` output: `<3> 1 3 2`<br>
`1 2 3 0 pick .s` output: `<4> 1 2 3 3`

### Return stack

`>r` `( x -- ) ( R: -- x )`<br>
`r>` `( -- x ) ( R: x -- )`<br>
`r@` `( -- x ) ( R: x -- x )`

The return stack can be used within a definition to keep data.

## Literals and Booleans

- Numbers are written directly: `42`, `-7` 
- Number intepretation depends on `base` (see below)
- Hex numbers can be prefixed with `$`
- `true` is `-1`
- `false` is `0`
- Any non-zero value is treated as true by conditional execution words (`if`, `while`, `until`)

## Operators

### Arithmetic

<table>
  <tr><td><em>( a b -- result )</em></td><td><code>+</code> <code>-</code> <code>*</code> <code>/</code> <code>mod</code> <code>max</code> <code>min</code></td></tr>
  <tr><td><em>( u1 u2 -- u )</em></td><td><code>umin</code> <code>umax</code></td></tr>
  <tr><td><em>( u1 u2 -- ud )</em></td><td><code>um*</code></td></tr>
  <tr><td><em>( a b -- rem quot )</em></td><td><code>/mod</code></td></tr>
  <tr><td><em>( ud u1 -- rem quot )</em></td><td><code>um/mod</code></td></tr>
  <tr><td><em>( n -- n' )</em></td><td><code>2*</code> <code>2/</code> <code>1+</code> <code>1-</code> <code>negate</code> <code>abs</code></td></tr>
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

### Double Number Arithmetic

<table>
  <tr><td><em>( n -- d )</em></td><td><code>s&gt;d</code></td></tr>
  <tr><td><em>( d1 d2 -- d3 )</em></td><td><code>d+</code> <code>d-</code></td></tr>
  <tr><td><em>( d -- d' )</em></td><td><code>dnegate</code></td></tr>
  <tr><td><em>( d -- flag )</em></td><td><code>d0=</code> <code>d0&lt;</code></td></tr>
</table>

## Memory Fetch and Store

One stack element holds a _cell_ which size depends on the machine type and Forth implementation, typically 16, 32 or 64 bits.

`@` `( addr -- x )` — fetch cell<br>
`!` `( x addr -- )` — store cell<br>
`c@` `( addr -- c )` — fetch byte<br>
`c!` `( c addr -- )` — store byte<br>
`+!` `( n addr -- )` — add to cell in memory

## Address Arithmetic

`cells` — converts cell counts to address offsets<br>
`cell+` — adjusts address to next cell<br>
`1+` or `char+` — adjust address to next byte

## Defining Variables and Constants

`variable <name>` — reserves space for one cell and creates a word returning the address<br>
`constant <name>` — creates a named value<br>

Examples:

```forth
variable counter
10 counter !
counter @ .

42 constant answer
answer .
```

## Reserving Data Space

A forth writes the program and data into a data space called _dictionary_.

`here ( -- addr )` — address of the next free byte<br>
`create <name>` — creates a word returning an address into the dictionary; space can be reserved with the next words<br>
`allot ( n -- )` — reserves bytes<br>
`, ( n -- )` — reserves space for a cell and stores it<br>
`c, ( c -- )` — reserves space for one byte and stores it

Examples:

```forth
\ identical to variable count, not initialised
create counter 1 cells allot

\ same, but initilised with 0
create counter 0 ,
```

## Number Output

`.` — prints top stack item<br>
`.s` — prints stack contents without consuming them<br>
`hex` — switches to hexadecimal output<br>
`decimal` — switches to decimal output<br>
`2 base !` — switches number output and input to base 2<br>
`base @ ( -- n )` — gets the active base

## Output and Strings

`emit` — prints one character<br>
`cr` — newline<br>
`space` — prints a space<br>
`type` `( addr len -- )` — prints a string<br>
`." hello"` — prints string during definition execution<br>
`s" hello"` `( -- addr len )` — puts string on the stack<br>
`count` `( c-addr1 -- c-addr2 u )` — turns a counted string into address and length<br>
`move` `( addr1 addr2 u -- )` — copies `u` bytes<br>
`place` `( addr u c-addr -- )` — stores as counted string

## Input

`key` `( -- c )` — reads one character<br>
`key?` `( -- f )` — `true` if input is available

## Conditional execution

Conditionals can only be used within a definition.

`( f ) if ... then`<br>
`( f ) if ... else ... then`

Example:

```forth
: my-abs ( n -- u )
  dup 0< if negate then ;
```

## Looping

Loops can only be used within a definition.

`begin ... again`<br>
`begin ... ( f ) until`<br>
`begin ... ( f ) while ... repeat`<br>
`( end+1 start ) do ... loop`<br>
`( end+1 start ) ?do ... loop` — for possibly skipped loops<br>
`( end+1 start ) do ... +loop`<br>
`leave` — exits a `do` loop early<br>
`i` — current loop index<br>
`j` — next outer loop index

Examples

```forth
: countdown ( n -- )
  begin dup . 1- dup 0< until drop ;

: stars ( n -- )
  0 do [char] * emit loop cr ;
```

## Debugging

`words` — prints available words<br>
`.s` — prints stack contents<br>
`.sh` — prints stack contents in hex (ec4th)<br>
`dump ( addr len -- )` — dumps memory contents (gforth/ec4th)

## Error codes

`-1` `abort`<br>
`-2` `abort"` — error with additional message<br>
`-3` / `-4` — stack overflow / underflow<br>
`-5` / `-6` — return stack overflow / underflow<br>
`-9` — invalid memory address<br>
`-10` — division by zero<br>
`-13` — undefined word<br>
`-14` — interpreting a compile-only word<br>
`-22` — control structure mismatch<br>
`-25` — return stack imbalance<br>
`-28` — user interrupt

## Indirect Execution

`( -- xt ) ' name` — gets the execution token of `name`<br>
`( xt -- ) execute` — runs an execution token

Examples:

````forth
: green ." green" ;
: blue ." blue" ;
variable phase
' green phase !
phase @ execute
````

## ec4th Arduino

`millis ( -- n )` — elapsed milliseconds<br>
`dmillis ( -- d )` — elapsed millis as double<br>
`dmicros ( -- d )` — elapsed microseconds as double<br>
`ms ( u -- )` — wait given milliseconds<br>
`io! ( c io-addr -- )` — store byte into the IO address<br>
`io@ ( io-addr -- c )` — fetch byte from IO address<br>
`pinb` `ddrb` `portb` — IO address constants for port B

````forth
255 ddrb io! \ make all pins of port B outputs
255 portb io! \ switch on everything connected
````
