extends Object

var pgonsides
var pgonexclude = [] # Pgon #s maked 'true' will not get child boss parts
var turrets = []

func new_turret():
	var t = preload("./BossDesignTurret.gd").new()
	turrets.append(t)
	return t