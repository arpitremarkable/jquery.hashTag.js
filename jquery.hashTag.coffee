Array::sub = (arr)	->
	return (x for x in @ when x not in arr)

Array::intersect = (arr)	->
	return (x for x in @ when x in arr)

Array::set = ()	->
	arr = []
	arr.push x for x in @ when x not in arr
	return arr

Array::slugify = 	->
	return (x.slugify() for x in @)

String::slugify = 	->
	return @.trim().replace(/\s+/g, ' ').replace(/[^a-zA-Z0-9\-]/g, ' ').replace(/(\s|\-)+/g, '_').toLowerCase()

$.fn.extend
	hashTag: (args...)	->
		return new HashTag @, args...

class HashTag
	constructor:	(@$target, options)	->
		_this = @
		defaults =
			clearAtLoad: true
			enableCtrlKey: false
			event: 'click'
			hash: []
			load:	()	->	$(@).trigger 'click'
			multi: false
			slugifySource: true
			source: ()	->	$(@).text()
			toggle: false

		for key, value of $.extend defaults, options
			@[key]=value

		# auto slugify source if permitted
		if @slugifySource
			@_source = @source
			@source = () ->
				return _this._source.apply(@, arguments).slugify()

		# trigger @load for incoming hash tags
		@old_hash = @splitHash(window.location.hash).sub @hash
		@trigger @load, @old_hash

		if @clearAtLoad then @old_hash = []
		@applyHash(@hash)
		$target[@event]	(e)->
			if _this.enableCtrlKey and (e.metaKey or e.ctrlKey)
				multi = true
				toggle = true
			else
				multi = _this.multi
				toggle = if _this.enableCtrlKey then false else _this.toggle
			tag = _this.source.apply @
			if not multi then _this.removeHash(_this.hash.sub [tag]) # remove rest of the hashes from @hash except tag hash
			if toggle then _this.toggleHash tag else _this.addHash tag # if toggle is enabled then use toggleHash
			_this.applyHash(_this.hash)

	addHash:	(hash)	->
		hash = [hash] if typeof hash isnt 'object'
		@hash = @hash.concat(hash).set()
		hash_intersection = @hash.intersect @old_hash
		@old_hash = @old_hash.sub hash_intersection

	removeHash:	(hash)	->
		hash = [hash] if typeof hash isnt 'object'
		@hash = @hash.sub hash

	toggleHash:	(hash)	->
		hash = [hash] if typeof hash isnt 'object'
		for tag in hash
			if tag in @hash then @removeHash tag else @addHash tag

	splitHash:	(hash)	->
		return (tag for tag in hash.split('#') when Boolean(tag))

	joinHash:	(hash)	->
		return "##{hash.join('#')}"

	applyHash:	(hash)	->
		window.location.hash = @joinHash @old_hash.concat(@hash).set()

	setTarget:	(hash, pre_callback, post_callback)	->
		$target = $()
		_this = @
		@$target.each	->
			if _this.source.apply(@) in hash
				$target.push @
		return $target

	trigger:	(fn, hash)	->
		$target = @setTarget hash.concat(@hash).set()
		[tags, _this] = [[], @]
		$target.each	->
			fn.apply @, arguments if fn?
			_this.source.apply @, arguments
		@addHash tags
