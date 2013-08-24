jquery.hashTag.js
=================

a jquery plugin that provides url hashTag support for target elements.

Usage:
---------

```javascript
  $('.ui-tabs .ui-tab-nav a').hashTag({
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
  });
```
