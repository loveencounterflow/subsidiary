(function() {
  'use strict';
  var Subsidiary;

  //===========================================================================================================
  Subsidiary = class Subsidiary {
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
    tie_all(cfg) {
      /* TAINT use types, validate */
      var enumerable, host, host_key, ref, subsidiary, subsidiary_key, template, y;
      template = {
        host: null,
        host_key: '_',
        enumerable: false
      };
      cfg = {...template, ...cfg};
      //.......................................................................................................
      ({host, host_key, enumerable} = cfg);
      ref = this.walk_subsidiaries(host);
      //.......................................................................................................
      for (y of ref) {
        ({subsidiary_key, subsidiary} = y);
        this.tie_host_and_subsidiary({host, subsidiary, host_key, subsidiary_key});
      }
      //.......................................................................................................
      return null;
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
  module.exports = {
    SUBSIDIARY: new Subsidiary(),
    Subsidiary
  };

}).call(this);

//# sourceMappingURL=main.js.map