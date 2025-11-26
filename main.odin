/*
	Simple game about enemies chasing and shooting you in 2D space.

	Original repo: https://github.com/wbogocki/Odin-Play

	To play:
		- Move with WSAD or arrow keys
		- Jump with Shift + direction
*/

package chase_in_space

import "core:fmt"
import "core:math/linalg"
import "vendor:sdl2"

Game :: struct {
	renderer:    ^sdl2.Renderer,
	keyboard:    []u8,
	time:        f64,
	dt:          f64,
	player:      Player,
	enemies:     [dynamic]Enemy,
	projectiles: [dynamic]Projectile,
}

get_time :: proc() -> f64 {
	return f64(sdl2.GetPerformanceCounter()) * 1000 / f64(sdl2.GetPerformanceFrequency())
}

main :: proc() {
	assert(sdl2.Init(sdl2.INIT_VIDEO) == 0, sdl2.GetErrorString())
	defer sdl2.Quit()

	window := sdl2.CreateWindow(
		"Odin Game",
		sdl2.WINDOWPOS_CENTERED,
		sdl2.WINDOWPOS_CENTERED,
		640,
		480,
		sdl2.WINDOW_SHOWN,
	)
	assert(window != nil, sdl2.GetErrorString())
	defer sdl2.DestroyWindow(window)

	// Must not do VSync because we run the tick loop on the same thread as rendering.
	renderer := sdl2.CreateRenderer(window, -1, sdl2.RENDERER_ACCELERATED)
	assert(renderer != nil, sdl2.GetErrorString())
	defer sdl2.DestroyRenderer(renderer)

	tickrate := 240.0
	ticktime := 1000.0 / tickrate

	game := Game {
		renderer    = renderer,
		time        = get_time(),
		dt          = ticktime,
		player      = make_player(),
		enemies     = make_enemies(),
		projectiles = make([dynamic]Projectile),
	}
	defer delete(game.enemies)
	defer delete(game.projectiles)

	dt := 0.0

	for {
		event: sdl2.Event
		for sdl2.PollEvent(&event) {
			#partial switch event.type {
			case .QUIT:
				return
			case .KEYDOWN:
				if event.key.keysym.scancode == sdl2.SCANCODE_ESCAPE {
					return
				}
			}
		}

		time := get_time()
		dt += time - game.time

		game.keyboard = sdl2.GetKeyboardStateAsSlice()
		game.time = time

		// Running on the same thread as rendering so in the end still limited by the rendering FPS.
		for dt >= ticktime {
			dt -= ticktime


			update_player(&game.player, &game, f32(dt))
			for _, i in game.enemies {
				update_enemy(&game.enemies[i], &game, f32(dt))
			}

			for _, i in game.projectiles {
				update_projectile(&game.projectiles[i], &game, f32(dt))
			}

			for i := 0; i < len(game.enemies); {
				if game.enemies[i].hp <= 0 {
					ordered_remove(&game.enemies, i)
				} else {
					i += 1
				}
			}
			for i := 0; i < len(game.projectiles); {
				if game.projectiles[i].hp <= 0 {
					ordered_remove(&game.projectiles, i)
				} else {
					i += 1
				}
			}
		}

		sdl2.SetRenderDrawColor(renderer, 0, 0, 0, 0)
		sdl2.RenderClear(renderer)
		render_player(&game.player, &game)
		for _, i in game.enemies {
			render_enemy(&game.enemies[i], &game)
		}
		for _, i in game.projectiles {
			render_projectile(&game.projectiles[i], &game)
		}
		sdl2.RenderPresent(renderer)
	}
}

