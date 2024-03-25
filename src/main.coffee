


'use strict'


#===========================================================================================================
class Subsidiary

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
    return null

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
  tie_all: ( cfg ) ->
    ### TAINT use types, validate ###
    template  = { host: null, host_key: '_', enumerable: false, }
    cfg       = { template..., cfg..., }
    #.......................................................................................................
    { host
      host_key
      enumerable      } = cfg
    #.......................................................................................................
    for { subsidiary_key, subsidiary, } from @walk_subsidiaries host
      @tie_one { host, subsidiary, host_key, subsidiary_key, }
    #.......................................................................................................
    return host

  #---------------------------------------------------------------------------------------------------------
  tie_one: ( cfg ) ->
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
    @subsidiaries.add subsidiary
    if @hosts.has subsidiary
      throw new Error "subsidiary already has a host"
    ### host->subsidiary is a standard containment/compository relationship and is expressed directly;
    subsidiary-> host is a backlink that would create a circular reference which we avoid by using a
    `WeakMap` instance, `@hosts`: ###
    Object.defineProperty host, subsidiary_key, { value: subsidiary, enumerable, }
    Object.defineProperty subsidiary, host_key, { get: ( => @get_host subsidiary ), enumerable, }
    @hosts.set subsidiary, host
    return host

  #---------------------------------------------------------------------------------------------------------
  get_host: ( subsidiary ) ->
    return R if ( R = @hosts.get subsidiary )?
    throw new Error "no host registered for object"


#===========================================================================================================
module.exports = { SUBSIDIARY: ( new Subsidiary ), Subsidiary, }

