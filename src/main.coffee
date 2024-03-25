


'use strict'


# #===========================================================================================================
# GUY                       = require 'guy'
# { alert
#   debug
#   help
#   info
#   plain
#   praise
#   urge
#   warn
#   whisper }               = GUY.trm.get_loggers 'intertalk'
# { rpr
#   inspect
#   echo
#   log     }               = GUY.trm
# WG                        = require '../../../apps/webguy'
# hub_s                     = Symbol.for 'hub'



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
module.exports = { SUBSIDIARY: ( new Subsidiary ), Subsidiary, }

