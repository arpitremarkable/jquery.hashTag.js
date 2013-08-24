// Generated by CoffeeScript 1.6.3
var HashTag,
  __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; },
  __slice = [].slice;

Array.prototype.sub = function(arr) {
  var x;
  return (function() {
    var _i, _len, _results;
    _results = [];
    for (_i = 0, _len = this.length; _i < _len; _i++) {
      x = this[_i];
      if (__indexOf.call(arr, x) < 0) {
        _results.push(x);
      }
    }
    return _results;
  }).call(this);
};

Array.prototype.intersect = function(arr) {
  var x;
  return (function() {
    var _i, _len, _results;
    _results = [];
    for (_i = 0, _len = this.length; _i < _len; _i++) {
      x = this[_i];
      if (__indexOf.call(arr, x) >= 0) {
        _results.push(x);
      }
    }
    return _results;
  }).call(this);
};

Array.prototype.set = function() {
  var arr, x, _i, _len;
  arr = [];
  for (_i = 0, _len = this.length; _i < _len; _i++) {
    x = this[_i];
    if (__indexOf.call(arr, x) < 0) {
      arr.push(x);
    }
  }
  return arr;
};

$.fn.extend({
  hashTag: function() {
    var args;
    args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
    return (function(func, args, ctor) {
      ctor.prototype = func.prototype;
      var child = new ctor, result = func.apply(child, args);
      return Object(result) === result ? result : child;
    })(HashTag, [this].concat(__slice.call(args)), function(){});
  }
});

HashTag = (function() {
  function HashTag($target, options) {
    var defaults, key, value, _ref, _this;
    this.$target = $target;
    defaults = {
      multi: false,
      toggle: false,
      enableCtrlKey: false,
      clearAtLoad: true,
      event: 'click',
      hash: [],
      source: function() {
        return this.text();
      },
      load: function() {
        return this.trigger('click');
      }
    };
    _ref = $.extend(defaults, options);
    for (key in _ref) {
      value = _ref[key];
      this[key] = value;
    }
    this.old_hash = this.splitHash(window.location.hash).sub(this.hash);
    this.trigger(this.load, this.old_hash);
    if (this.clearAtLoad) {
      this.old_hash = [];
    }
    this.applyHash(this.hash);
    _this = this;
    $target[this.event](function(e) {
      var $this, multi, tag, toggle;
      if (_this.enableCtrlKey && (e.metaKey || e.ctrlKey)) {
        multi = true;
        toggle = true;
      } else {
        multi = _this.multi;
        toggle = _this.enableCtrlKey ? false : _this.toggle;
      }
      $this = $(this);
      tag = _this.source.apply($this);
      if (!multi) {
        _this.removeHash(_this.hash.sub([tag]));
      }
      if (toggle) {
        _this.toggleHash(tag);
      } else {
        _this.addHash(tag);
      }
      return _this.applyHash(_this.hash);
    });
  }

  HashTag.prototype.addHash = function(hash) {
    var hash_intersection;
    if (typeof hash !== 'object') {
      hash = [hash];
    }
    this.hash = this.hash.concat(hash).set();
    hash_intersection = this.hash.intersect(this.old_hash);
    return this.old_hash = this.old_hash.sub(hash_intersection);
  };

  HashTag.prototype.removeHash = function(hash) {
    if (typeof hash !== 'object') {
      hash = [hash];
    }
    return this.hash = this.hash.sub(hash);
  };

  HashTag.prototype.toggleHash = function(hash) {
    var tag, _i, _len, _results;
    if (typeof hash !== 'object') {
      hash = [hash];
    }
    _results = [];
    for (_i = 0, _len = hash.length; _i < _len; _i++) {
      tag = hash[_i];
      if (__indexOf.call(this.hash, tag) >= 0) {
        _results.push(this.removeHash(tag));
      } else {
        _results.push(this.addHash(tag));
      }
    }
    return _results;
  };

  HashTag.prototype.splitHash = function(hash) {
    var tag;
    return (function() {
      var _i, _len, _ref, _results;
      _ref = hash.split('#');
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        tag = _ref[_i];
        if (Boolean(tag)) {
          _results.push(tag);
        }
      }
      return _results;
    })();
  };

  HashTag.prototype.joinHash = function(hash) {
    return "#" + (hash.join('#'));
  };

  HashTag.prototype.applyHash = function(hash) {
    return window.location.hash = this.joinHash(this.old_hash.concat(this.hash).set());
  };

  HashTag.prototype.setTarget = function(hash, pre_callback, post_callback) {
    var $target, _this;
    $target = $();
    _this = this;
    this.$target.each(function() {
      var __this, _ref;
      __this = $(this);
      if (_ref = _this.source.apply(__this), __indexOf.call(hash, _ref) >= 0) {
        return $target.push(this);
      }
    });
    return $target;
  };

  HashTag.prototype.trigger = function(fn, hash) {
    var $target;
    $target = this.setTarget(hash.concat(this.hash).set());
    if (fn != null) {
      fn.apply($target);
    }
    return this.addHash(this.source.apply($target));
  };

  return HashTag;

})();