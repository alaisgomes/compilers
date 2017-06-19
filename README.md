# CSCI475 / Spring 2016
## Compilers Complimentary Exam
 
### About
Practical complimentary exam for Compilers class divided in 3 parts, developed through the course as the exams were.
The code is devided in different files:
* html.h
* html.tab.c
* html.y
* lex.yy.c
* html.l
* html.m

Executing instructions (with trace flag):
```sh
make
cat <input_file> | ./html -t
```

### Part 1 - Exam 1
With a basic BNF Grammar for HTML, it was developed the tokenizer that outputs the lexeme-token pairs from the parsing.
Grammar: 

```
<START> := <doc>
<doc> := &epsilon; | <code> <doc> | <text> <doc> | <comment> <doc> | <bangtag> <doc> | <start_tag> <doc> <end_tag> <doc> | <sc_tag> <doc>
<start_tag> := '<' <tag_name> <attr_seq> '>'
<sc_tag> := '<' <tag_name> <attr_seq> '/>'
<attr_seq> :=  &epsilon; | <attr> <attr_seq>
<attr> := <attr_name> '=' <attr_value>
<attr_name> := <ident>
<tag_name> := <ident>
<code> := /*starts with & and ends with ; but there`s no ampersand and semicolon in the middle */
<bangtag> := '<!' a pattern of almost any characters but not beginning with a dash '>'
<comment> := '<!--' a paterrn of almost any characters -->
<attr_value> := '"' a pattern of almost any characters '"'
<ident> := a pattern of alpha-numerics, underscores and dashes
<text> := a pattern of basically any characters except & , > , < , "
```
For the almost any characters described above, it was discussed in group in class to decide what could be valid or not and confirmed by the professor later for the exercise to be done.

### Part 2 - Exam 2
* All possible changes should be done to the code, to fit the requirements below. Grammar could be changed.
* It was added changed to previous programs, making it check for syntax. If there are syntax errors, output should be error message telling what type of error happened and at what line of the parsing code. If there are no errors, there should be no output, unless trace flag is activated (-t).
* Tracing flag makes the program display all parsing and reduction messages. 

### Part 3 - Exam 3
* Fix errors
* Add rule to detect php tags
    <doc> := <PHP> <doc>
* Php tag starts with '<?php' and eds with ?> 
    * Internals of tag does not need to be processed
* Added semantic rules to grammar. Main ones:
    * Must have only one <html> tag and it can have values and atributes
    * <body> and <head> tags should only exist within <html> tag
    * If both exists, <head> should ve before <body> and should exist only one at maximum of each
    * FOr each start tag there must be a closing tag
    * Tags cannot be crossed over (eg: <a><b></a></b> does not exist)

