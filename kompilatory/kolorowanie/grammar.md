# info

[source](https://www.lua.org/manual/5.1/manual.html)

# grammar

```ebnf

chunk ::= {stat [`;´]} [laststat [`;´]]

block ::= chunk

stat ::=  varlist `=´ explist |
     functioncall |
     do block end |
     while exp do block end |
     repeat block until exp |
     if exp then block {elseif exp then block} [else block] end |
     for Name `=´ exp `,´ exp [`,´ exp] do block end |
     for namelist in explist do block end |
     function funcname funcbody |
     local function Name funcbody |
     local namelist [`=´ explist]

laststat ::= return [explist] | break

funcname ::= Name {`.´ Name} [`:´ Name]

varlist ::= var {`,´ var}

var ::=  Name | prefixexp `[´ exp `]´ | prefixexp `.´ Name

namelist ::= Name {`,´ Name}

explist ::= {exp `,´} exp

exp ::=  nil | false | true | Number | String | `...´ | function |
     prefixexp | tableconstructor | exp binop exp | unop exp

prefixexp ::= var | functioncall | `(´ exp `)´

functioncall ::=  prefixexp args | prefixexp `:´ Name args

args ::=  `(´ [explist] `)´ | tableconstructor | String

function ::= function funcbody

funcbody ::= `(´ [parlist] `)´ block end

parlist ::= namelist [`,´ `...´] | `...´

tableconstructor ::= `{´ [fieldlist] `}´

fieldlist ::= field {fieldsep field} [fieldsep]

field ::= `[´ exp `]´ `=´ exp | Name `=´ exp | exp

fieldsep ::= `,´ | `;´

binop ::= `+´ | `-´ | `*´ | `/´ | `^´ | `%´ | `..´ |
     `<´ | `<=´ | `>´ | `>=´ | `==´ | `~=´ |
     and | or

unop ::= `-´ | not | `#´

```

# Identifiers

Names (also called identifiers) in Lua can be any string of
letters, digits, and underscores, not beginning with a
digit. This coincides with the definition of names in most
languages. (The definition of letter depends on the current
locale: any character considered alphabetic by the current
locale can be used in an identifier.) Identifiers are used
to name variables and table fields.

The following keywords are reserved and cannot be used as names:

```
     and       break     do        else      elseif
     end       false     for       function  if
     in        local     nil       not       or
     repeat    return    then      true      until     while
```

Lua is a case-sensitive language: and is a reserved word,
but And and AND are two different, valid names. As a
convention, names starting with an underscore followed by
uppercase letters (such as \_VERSION) are reserved for
internal global variables used by Lua.

The following strings denote other tokens:

```
     +     -     *     /     %     ^     #
     ==    ~=    <=    >=    <     >     =
     (     )     {     }     [     ]
     ;     :     ,     .     ..    ...
```

Literal strings can be delimited by matching single or
double quotes, and can contain the following C-like escape
sequences: '\a' (bell), '\b' (backspace), '\f' (form feed),
'\n' (newline), '\r' (carriage return), '\t' (horizontal
tab), '\v' (vertical tab), '\\' (backslash), '\"'
(quotation mark [double quote]), and '\'' (apostrophe
[single quote]). Moreover, a backslash followed by a real
newline results in a newline in the string. A character in
a string can also be specified by its numerical value using
the escape sequence \ddd, where ddd is a sequence of up to
three decimal digits. (Note that if a numerical escape is
to be followed by a digit, it must be expressed using
exactly three digits.) Strings in Lua can contain any 8-bit
value, including embedded zeros, which can be specified as
'\0'.

Literal strings can also be defined using a long format
enclosed by long brackets. We define an opening long
bracket of level n as an opening square bracket followed by
n equal signs followed by another opening square bracket.
So, an opening long bracket of level 0 is written as [[, an
opening long bracket of level 1 is written as [=[, and so
on. A closing long bracket is defined similarly; for
instance, a closing long bracket of level 4 is written as
]====]. A long string starts with an opening long bracket
of any level and ends at the first closing long bracket of
the same level. Literals in this bracketed form can run for
several lines, do not interpret any escape sequences, and
ignore long brackets of any other level. They can contain
anything except a closing bracket of the proper level.

For convenience, when the opening long bracket is
immediately followed by a newline, the newline is not
included in the string. As an example, in a system using
ASCII (in which 'a' is coded as 97, newline is coded as 10,
and '1' is coded as 49), the five literal strings below
denote the same string:

```
     a = 'alo\n123"'
     a = "alo\n123\""
     a = '\97lo\10\04923"'
     a = [[alo
     123"]]
     a = [==[
     alo
     123"]==]
```

A numerical constant can be written with an optional
decimal part and an optional decimal exponent. Lua also
accepts integer hexadecimal constants, by prefixing them
with 0x. Examples of valid numerical constants are

```
     3   3.0   3.1416   314.16e-2   0.31416E1   0xff   0x56
```

A comment starts with a double hyphen (--) anywhere outside
a string. If the text immediately after -- is not an
opening long bracket, the comment is a short comment, which
runs until the end of the line. Otherwise, it is a long
comment, which runs until the corresponding closing long
bracket. Long comments are frequently used to disable code
temporarily.
