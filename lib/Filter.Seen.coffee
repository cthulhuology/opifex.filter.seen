# Filter.Seen.coffee
#
#	© 2013 Dave Goehrig <dave@dloh.org>
#

Seen = () ->
	self = this
	self.duration = 24 * 60 # 24 hours in minutes
	self.seen = {}
	self['.filter'] = (x) -> x.id || x.guid || x
	self.filter = (code...) ->
		self[".filter"] = Function.prototype.constructor.apply(self,code)
	self["*"] = (message...) ->
		item = this['.filter']?.apply(self,message)
		if not self.seen[item]
			self.seen[item] = self.duration
			self.send message
	self.purge = (k) ->
		self.seen[k] -= 1
		delete self.seen[k] if self.seen[k] <= 0
	setInterval( () ->
		self.purge(k) for k of self.seen
	, 60 * 1000)		# each minute tick off 1 from seen duration

module.exports = Seen
