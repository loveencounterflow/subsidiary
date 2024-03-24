(async function() {
  'use strict';
  var Host, SUBSIDIARY, Subsidiary_helpers, log;

  // #===========================================================================================================
  // GUY                       = require 'guy'
  // { alert
  //   debug
  //   help
  //   info
  //   plain
  //   praise
  //   urge
  //   warn
  //   whisper }               = GUY.trm.get_loggers 'intertalk'
  // { rpr
  //   inspect
  //   echo
  //   log     }               = GUY.trm
  // WG                        = require '../../../apps/webguy'
  // hub_s                     = Symbol.for 'hub'
  ({log} = console);

  //===========================================================================================================
  Subsidiary_helpers = class Subsidiary_helpers {
    //---------------------------------------------------------------------------------------------------------
    constructor() {
      this.subsidiaries = new WeakSet();
      this.hosts = new WeakMap();
    }

    //---------------------------------------------------------------------------------------------------------
    * walk_subsidiaries(host) {
      var results, subsidiary, subsidiary_key;
      results = [];
      for (subsidiary_key in host) {
        subsidiary = host[subsidiary_key];
        if (this.is_subsidiary(subsidiary)) {
          /* TAINT this loop should be changed so we catch all relevant objects, including from inherited classes */
          results.push((yield {subsidiary_key, subsidiary}));
        }
      }
      return results;
    }

    //---------------------------------------------------------------------------------------------------------
    create(subsidiary) {
      if (this.subsidiaries.has(subsidiary)) {
        throw new Error("object already in use as subsidiary");
      }
      this.subsidiaries.add(subsidiary);
      return subsidiary;
    }

    //---------------------------------------------------------------------------------------------------------
    /* TAINT safeguard against non-object values */
    is_subsidiary(x) {
      return this.subsidiaries.has(x);
    }

    //---------------------------------------------------------------------------------------------------------
    tie_host_and_subsidiary(cfg) {
      /* TAINT use types, validate */
      var enumerable, host, host_key, subsidiary, subsidiary_key, template;
      template = {
        host: null,
        subsidiary: null,
        subsidiary_key: '$',
        host_key: '_',
        enumerable: false
      };
      cfg = {...template, ...cfg};
      //.......................................................................................................
      ({host, subsidiary, host_key, subsidiary_key, enumerable} = cfg);
      //.......................................................................................................
      log('^340-1^', cfg);
      /* TAINT shouldn't be necessary if done explicitly? */
      if (!this.subsidiaries.has(subsidiary)) {
        throw new Error("object isn't a subsidiary");
      }
      if (this.hosts.has(subsidiary)) {
        throw new Error("subsidiary already has a host");
      }
      /* host->subsidiary is a standard containment/compository relationship and is expressed directly;
         subsidiary-> host is a backlink that would create a circular reference which we avoid by using a
         `WeakMap` instance, `@hosts`: */
      Object.defineProperty(host, subsidiary_key, {
        value: subsidiary,
        enumerable
      });
      Object.defineProperty(subsidiary, host_key, {
        get: (() => {
          return this.get_host(subsidiary);
        }),
        enumerable
      });
      this.hosts.set(subsidiary, host);
      return subsidiary;
    }

    //---------------------------------------------------------------------------------------------------------
    get_host(subsidiary) {
      var R;
      if ((R = this.hosts.get(subsidiary)) != null) {
        return R;
      }
      throw new Error("no host registered for object");
    }

  };

  //===========================================================================================================
  SUBSIDIARY = new Subsidiary_helpers();

  Host = (function() {
    var B;

    //===========================================================================================================
    class Host {
      //---------------------------------------------------------------------------------------------------------
      constructor() {
        var ref, subsidiary, subsidiary_key, y;
        ref = SUBSIDIARY.walk_subsidiaries(this);
        for (y of ref) {
          ({subsidiary_key, subsidiary} = y);
          SUBSIDIARY.tie_host_and_subsidiary({
            host: this,
            subsidiary,
            host_key: '_',
            subsidiary_key
          });
          log('^233-1^', subsidiary_key, SUBSIDIARY.is_subsidiary(subsidiary), subsidiary._ === this);
          log('^233-1^', this[subsidiary_key]);
        }
        return void 0;
      }

      //---------------------------------------------------------------------------------------------------------
      show() {
        log('^650-1^', this);
        log('^650-2^', this.$a, this.$a.show);
        log('^650-2^', this.$b, this.$b.show);
        return null;
      }

    };

    //---------------------------------------------------------------------------------------------------------
    Host.prototype.$a = SUBSIDIARY.create({
      show: function() {
        log('^650-1^', "$a.show");
        this._.show();
        return null;
      }
    });

    //---------------------------------------------------------------------------------------------------------
    Host.prototype.$b = SUBSIDIARY.create(new (B = class B {
      show() {
        log('^650-1^', "$b.show");
        this._.show();
        return null;
      }

    })());

    //---------------------------------------------------------------------------------------------------------
    Host.prototype.$not_a_subsidiary = {};

    return Host;

  }).call(this);

  //===========================================================================================================
  if (module === require.main) {
    await (() => {
      var h, host, subsidiary;
      h = new Host();
      h.show();
      h.$a.show();
      h.$b.show();
      //.........................................................................................................
      host = {
        a: true
      };
      subsidiary = SUBSIDIARY.create({
        b: true
      });
      SUBSIDIARY.tie_host_and_subsidiary({
        host,
        subsidiary,
        enumerable: true
      });
      log('^722-1^', host);
      log('^722-1^', host.$);
      log('^722-1^', subsidiary);
      return log('^722-1^', subsidiary._);
    })();
  }

}).call(this);

//# sourceMappingURL=main.js.map