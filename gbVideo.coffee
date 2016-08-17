class gbVideo
	_evtMap: {}

	currTime: 0
	totalTime: 0

	progress: 0

	constructor: (@video)->
		_this = @
		@video.addEventListener('play', (e)->
			_this._trigger('play')
		)

		@video.addEventListener('pause', (e)->
			_this._trigger('pause')
		)

		@video.addEventListener('ended', (e)->
			_this._trigger('ended')
		)

		@video.addEventListener('timeupdate', (e)->
			_this.currentTime = e.target.currentTime;
			_this.progress = Math.floor(_this.currentTime * 100 / _this.totalTime) / 100
			_this._trigger('playing')
		)

		@video.addEventListener('loadedmetadata', (e)->
			_this.totalTime = e.target.duration;
			_this._trigger('ready')
		)

	play: ->
		@video.play()
	pause: ->
		@video.pause()
	gotoPlay: (time)->
		@video.currentTime = time;
		@play()
	source: (url)->
		@video.src = url

	on: (evt, fn)->
		if @_evtMap[evt] is undefined
			@_evtMap[evt] = []
		@_evtMap[evt].push fn

	_trigger: (evt, data = {})->
		arr = @_evtMap[evt]
		if(arr is undefined ) then arr = []

		evtObj = {target: @}

		for i of data
			if i isnt 'target'
				evtObj[i] = data[i]

		for fn in arr
			if typeof fn is "function" then fn(evtObj)

window.gbVideo = gbVideo