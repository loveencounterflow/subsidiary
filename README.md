


# Subsidiary


<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [Subsidiary](#subsidiary)
  - [Example #1](#example-1)
  - [Example #1](#example-1-1)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


# Subsidiary

`subsidiary` is a small tool to create circular (but GC-friendly where it matters) links between two
objects.

host->subsidiary is a standard containment/compository relationship and is expressed directly;
subsidiary-> host is a backlink that would create a circular reference which we avoid by using a
`WeakMap` instance, `SUBSIDIARY.hosts`

## Example #1

* In this example, `SUBSIDIARY.tie_all()` is passed the `host` instance (`@ === this`), a `host_key` to
  specify under which key the `host` will be accessible from its subsidiaries


```coffee
  { SUBSIDIARY } = require 'subsidiary'

  #=========================================================================================================
  class Host

    #-------------------------------------------------------------------------------------------------------
    constructor: ->
      SUBSIDIARY.tie_all { host: @, host_key: '_', enumerable: true, }
      return undefined

    #-------------------------------------------------------------------------------------------------------
    ### using a plain object ###
    $a: SUBSIDIARY.create
      $a: true
      f: -> ...
      g: -> ...

    #-------------------------------------------------------------------------------------------------------
    ### using an ad-hoc instance ###
    $b: SUBSIDIARY.create new class B
      $b: true
      f: -> ...
      g: -> ...

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
