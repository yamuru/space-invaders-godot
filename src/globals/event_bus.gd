extends Node


# Event bus solves signal hell problem when
# you need to emit signal to your parent's parent's parent
# Also makes things easier when you need to notify a lot of nodes

enum Events {
	DirectionToggleAreaEntered,
	EnemyDied,
}

var subscriptions := []


func subscribe(event: int, node: Node, f: String, arg: Variant = false):
	subscriptions.append({
		event = event,
		node = node,
		f = f,
		arg = arg
	})


func notify(event: int, arg: Variant = null):
	for subscription in subscriptions:
		if subscription.event == event:
			if subscription.arg and arg:
				subscription.node.call_deferred(subscription.f, arg)
			else:
				subscription.node.call_deferred(subscription.f)


func remove_sub(event: int, node: Node, f: String):
	var positions_to_remove: Array = []
	
	for i in range(0, subscriptions.size()):
		var sub = subscriptions[i]
		if sub.event == event and sub.node == node and sub.f == f:
			positions_to_remove.append(i)
	
	for _j in range(0, positions_to_remove.size()):
		var position = positions_to_remove.pop_back()
		subscriptions.remove_at(position)


func remove_all_subs():
	subscriptions = []
