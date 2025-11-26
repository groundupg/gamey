package chase_in_space


Projectile :: struct {
	hp:             int,
	pos:            [2]f32,
	vel:            [2]f32,
	reload_counter: f32,
	bullet_decay:   f32,
	dash_counter:   f32,
}

update_projectile :: proc(entity: ^Entity, game: ^Game, dt: f32) {
	entity.pos += entity.vel * dt
	entity.bullet_decay -= 1.0 * dt
	if entity.bullet_decay < 0 {
		entity.hp = 0
	} else {
		player := find_entity(.PLAYER, game)
		if player == nil {return}
		if player.pos.x < entity.pos.x &&
		   entity.pos.x < player.pos.x + 10 &&
		   player.pos.y < entity.pos.y &&
		   entity.pos.y < player.pos.y + 10 {
			player.hp -= 1
			fmt.printf("HIT (HP: {})\n", player.hp)
			entity.hp = 0
		}
	}
}

