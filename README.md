


# Subsidiary


<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [Subsidiary](#subsidiary)
  - [Motivation](#motivation)
  - [Implementation](#implementation)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


# Subsidiary

small tool to create circular but GC-friendly links between two objects

## Motivation

I first had in mind to use an ingenious / tricky / treacherous construction that would allow the 'secondary'
to reference methods on the host / primary using `this` / `@`; this would have allowed both the primary and
the secondary to use a unified notation like `@f`, `@$.f` to reference `f` on the primary and on the
secondary. However this also would be surprising because now `this` means not the secondary, but the primary
instance in methods of the secondary instance which is too surprising to sound right.

Instead, we're using composition, albeit with a backlink.

## Implementation

host->subsidiary is a standard containment/compository relationship and is expressed directly;
subsidiary-> host is a backlink that would create a circular reference which we avoid by using a
`WeakMap` instance, `SUBSIDIARY.hosts`



<!-- ## To Do -->

<!-- * **`[–]`** -->

<!-- ## Is Done -->

<!-- * **`[+]`** -->
