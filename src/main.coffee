


'use strict'


#===========================================================================================================
GUY                       = require 'guy'
{ alert
  debug
  help
  info
  plain
  praise
  urge
  warn
  whisper }               = GUY.trm.get_loggers 'intertalk'
{ rpr
  inspect
  echo
  log     }               = GUY.trm
# WG                        = require '../../../apps/webguy'
# hub_s                     = Symbol.for 'hub'


###

**Note**: I first had in mind to use an ingenious / tricky / treacherous construction that would allow the
'secondary' to reference methods on the host / primary using `this` / `@`; this would have allowed both the
primary and the secondary to use a unified notation like `@f`, `@$.f` to reference `f` on the primary and on
the secondary. However this also would be surprising because now `this` means not the secondary, but the
primary instance in methods of the secondary instance which is too surprising to sound right.

Instead, we're using composition, albeit with a backlink.

###




#===========================================================================================================
class Subsidiary_helpers

  #---------------------------------------------------------------------------------------------------------
  constructor: ->
    @subsidiaries = new WeakSet()
    @hosts        = new WeakMap()

  #---------------------------------------------------------------------------------------------------------
  walk_subsidiaries: ( host ) ->
    ### TAINT this loop should be changed so we catch all relevant objects, including from inherited classes ###
    yield { subsidiary_key, subsidiary, } \
      for subsidiary_key, subsidiary of host \
        when @is_subsidiary subsidiary

  #---------------------------------------------------------------------------------------------------------
  create: ( subsidiary ) ->
    if @subsidiaries.has subsidiary
      throw new Error "object already in use as subsidiary"
    @subsidiaries.add subsidiary
    return subsidiary

  #---------------------------------------------------------------------------------------------------------
  ### TAINT safeguard against non-object values ###
  is_subsidiary: ( x ) -> @subsidiaries.has x

  #---------------------------------------------------------------------------------------------------------
  tie_host_and_subsidiary: ( cfg ) ->
    ### TAINT use types, validate ###
    template  = { host: null, subsidiary: null, subsidiary_key: '$', host_key: '_', enumerable: false, }
    cfg       = { template..., cfg..., }
    #.......................................................................................................
    { host
      subsidiary
      host_key
      subsidiary_key
      enumerable      } = cfg
    #.......................................................................................................
    debug '^340-1^', cfg
    ### TAINT shouldn't be necessary if done explicitly? ###
    unless @subsidiaries.has subsidiary
      throw new Error "object isn't a subsidiary"
    if @hosts.has subsidiary
      throw new Error "subsidiary already has a host"
    ### host->subsidiary is a standard containment/compository relationship and is expressed directly;
    subsidiary-> host is a backlink that would create a circular reference which we avoid by using a
    `WeakMap` instance, `@hosts`: ###
    Object.defineProperty host, subsidiary_key, { value: subsidiary, enumerable, }
    Object.defineProperty subsidiary, host_key, { get: ( => @get_host subsidiary ), enumerable, }
    @hosts.set subsidiary, host
    return subsidiary

  #---------------------------------------------------------------------------------------------------------
  get_host: ( subsidiary ) ->
    return R if ( R = @hosts.get subsidiary )?
    throw new Error "no host registered for object"

#===========================================================================================================
SUBSIDIARY = new Subsidiary_helpers

#===========================================================================================================
class Host

  #---------------------------------------------------------------------------------------------------------
  constructor: ->
    for { subsidiary_key, subsidiary, } from SUBSIDIARY.walk_subsidiaries @
      SUBSIDIARY.tie_host_and_subsidiary { host: @, subsidiary, host_key: '_', subsidiary_key, }
      debug '^233-1^', subsidiary_key, ( SUBSIDIARY.is_subsidiary subsidiary ), ( subsidiary._ is @ )
      debug '^233-1^', @[ subsidiary_key ]
    #   continue unless subsidiary_key.startsWith '$'
    #   debug '^233-2^', subsidiary_key, subsidiary, subsidiary?.prototype
    # @$ = new Secondary @
    return undefined

  #---------------------------------------------------------------------------------------------------------
  show: ->
    help '^650-1^', @
    help '^650-2^', @$a, @$a.show
    help '^650-2^', @$b, @$b.show
    return null

  #---------------------------------------------------------------------------------------------------------
  $a: SUBSIDIARY.create
    show: ->
      warn '^650-1^', "$a.show"
      @_.show()
      return null

  #---------------------------------------------------------------------------------------------------------
  $b: SUBSIDIARY.create new class B
    show: ->
      warn '^650-1^', "$b.show"
      @_.show()
      return null

  #---------------------------------------------------------------------------------------------------------
  $not_a_subsidiary: {}


#===========================================================================================================
if module is require.main then await do =>
  h = new Host()
  h.show()
  h.$a.show()
  h.$b.show()
  #.........................................................................................................
  host        = { a: true, }
  subsidiary  = SUBSIDIARY.create { b: true, }
  SUBSIDIARY.tie_host_and_subsidiary { host, subsidiary, enumerable: true, }
  urge '^722-1^', host
  urge '^722-1^', host.$
  urge '^722-1^', subsidiary
  urge '^722-1^', subsidiary._
