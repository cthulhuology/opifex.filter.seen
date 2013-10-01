Opifex.filter.seen
=================

Filters messages based on having seen some characteristic of the data before


Getting Started:
----------------

The best way to see how to use opifex.filter.seen is with an RSS example:

	opifex 'amqp://guest:guest@localhost:5672//rss-out/#/seen/seen-out/saw' filter.seen

Here we're mapping everything on the rss-out exchange to the seen queue, and on which the filter reads.
The filter then outputs all of the not yet seen content to the seen-out exchange.

Once running we can then send a command and control message to tell filter.seen how to filter
RSS feeds by injecting code over the bus:

	[ "put", "/rss-out/filter", "filter",  "method", "article", "return article.guid" ]

The above message is using the WebSocket pontifex bridge.  What it means is as follows:

	"put" 			-> send the remainder of this message to a named resource path
	"/rss-out/filter"	-> send it to the rss-out exchange, routing key filter
					payload is: [ "filter", "method", "article", "return article.guid" ]
	"filter"		-> method of the recipient to execute
	"method"		-> first parameter of the anonymous function we'll use to filter seen objects
	"article"		-> second parameter of the anonymous function we'll use to filter seen objects
	"return article.guid"	-> body of the filter function

This create a new anonymous function:

	function (method,article {
		return article.guid;
	}

Which will be used to identify which rss articles have been seen.  


