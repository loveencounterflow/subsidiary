


# Subsidiary


<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [Subsidiary](#subsidiary)
  - [Example: Plain Objects](#example-plain-objects)
  - [Example: Class with Several Subsidiaries](#example-class-with-several-subsidiaries)
  - [Example #1](#example-1)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


# Subsidiary

`subsidiary` is a small tool to create circular (but GC-friendly where it matters) links between two
objects.

host->subsidiary is a standard containment/compository relationship and is expressed directly;
subsidiary-> host is a backlink that would create a circular reference which we avoid by using a
`WeakMap` instance, `SUBSIDIARY.hosts`

## Example: Plain Objects

```coffee
{ SUBSIDIARY }  = require 'subsidiary'
a               = { is_a: true, value: 17, }
b               = { is_b: true, value: 4, }
SUBSIDIARY.tie_one { host: a, subsidiary: b, subsidiary_key: 'b', host_key: 'a', enumerable: true }
log '^xpo@1^', a.b    is b
log '^xpo@2^', a.b.a  is a
log '^xpo@3^', a
log '^xpo@4^', b

# Output:
#   ^xpo@1^ true
#   ^xpo@2^ true
#   ^xpo@3^ { is_a: true, value: 17, b: { is_b: true, value: 4, a: [Getter] } }
#   ^xpo@4^ { is_b: true, value: 4, a: [Getter] }
```

## Example: Class with Several Subsidiaries

In this example, `SUBSIDIARY.tie_all()` is passed the `host` instance (`@ === this`) and a `host_key` of
(`'_'`, the default value) to specify under which key the `host` will be accessible from its subsidiaries;
`enumerable` has not been set to `true`, so the host key will not show up in key enumerations as returned by
e.g. `Object.keys subsidiary`. Using the `SUBSIDIARY.tie_all()` method requires that subsidiary objects are
explicitly marked up as such by calling `SUBSIDIARY.create obj`; this will not affect the marked `obj`ect in
any way other than adding it to the `WeakSet` (accessible as `SUBSIDIARY.subsidiaries`).


```coffee
{ SUBSIDIARY } = require 'subsidiary'

#=========================================================================================================
class Host

  #-------------------------------------------------------------------------------------------------------
  constructor: ->
    SUBSIDIARY.tie_all { host: @, host_key: '_', }
    return undefined

  #-------------------------------------------------------------------------------------------------------
  ### using a plain object ###
  $a: SUBSIDIARY.create
    $a: true
    f: -> null ### whatever ###
    g: -> null ### whatever ###

  #-------------------------------------------------------------------------------------------------------
  ### using an ad-hoc instance ###
  $b: SUBSIDIARY.create new class B
    $b: true
    f: -> null ### whatever ###
    g: -> null ### whatever ###

  #-------------------------------------------------------------------------------------------------------
  ### using an instance ###
  $b: SUBSIDIARY.create new class C
```

## Example #1



```coffee
```

```coffee
```

```coffee
```

```coffee
```

<!-- ## To Do -->

<!-- * **`[–]`** -->

<!-- ## Is Done -->

<!-- * **`[+]`** -->
