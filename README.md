# jquery.hashTag.js

a jquery plugin that provides url hashTag support for target elements.

## Usage:

### coffee
```coffeescript
  $(".ui-tabs .ui-tab-nav a").hashTag
    multi: false
    toggle: false
    enableCtrlKey: false
    clearAtLoad: true
    event: "click"
    hash: []
    source: ->
      @text()
  
    load: ($target) ->
      $target.trigger "click"
```
### js
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
    load: function($target) {
      return $target.trigger('click');
    }
  });
```
## Milestones
### v0.1
- [x] get the project up and running with bare minimum options.
- [x] create a jquery plugin and auto-inherit target elements

### v0.2
- [x] slugify option => hash source will be auto [slugged](http://stackoverflow.com/questions/427102/what-is-a-slug-in-django)
- [x] function chaining support for library functions, just like jquery chaining
- [x] prepare an example, preferable showing support for jquery-ui tabs

### x.x
- [ ] Custom slugify function
- [ ] Track browser back and forward (hashChange) events
- [ ] Provide option for window scope eg. window | top | document etc
- [ ] Allow multiple event options and bind them with dynamic elements as well
=======
