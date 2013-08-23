Array::sub = (arr)	->
	return (x for x in @ when x not in arr)

Array::intersect = (arr)	->
	return (x for x in @ when x in arr)

Array::set = ()	->
	arr = []
	arr.push x for x in @ when x not in arr
	return arr

$.fn.extend
	hashTag: (args...)	->
		return new HashTag @, args...

class HashTag
	constructor:	(@$target, options)	->
		defaults =
			multi: false
			toggle: false
			enableCtrlKey: false
			clearAtLoad: true
			event: 'click'
			hash: []
			source: ()	->	@text()
			load:	($target)	-> $target.trigger 'click'

		for key, value of $.extend defaults, options
    		@[key]=value

    	# trigger @load for incoming hash tags
    	@old_hash = @splitHash(window.location.hash).sub @hash
		@trigger @load, @old_hash

		if @clearAtLoad then @old_hash = []
		@applyHash(@hash)
		_this = @
		$target[@event]	(e)->
			if _this.enableCtrlKey and (e.metaKey or e.ctrlKey)
				multi = true
				toggle = true
			else
				multi = _this.multi
				toggle = if _this.enableCtrlKey then false else _this.toggle
			$this = $ @
			tag = _this.source.apply($this)
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
			__this= $(@)
			if _this.source.apply(__this) in hash
				$target.push @
		return $target

	trigger:	(fn, hash)	->
		$target = @setTarget hash.concat(@hash).set()
		if fn? then fn.apply($target)
		@addHash @source.apply $target