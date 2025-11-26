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
	renderer: ^sdl2.Renderer,
	keyboard: []u8,
	time:     f64,
	dt:       f64,
	entities: [dynamic]Entity,
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
		renderer = renderer,
		time     = get_time(),
		dt       = ticktime,
		entities = make([dynamic]Entity),
	}
	defer delete(game.entities)

	append(&game.entities, Entity{type = .PLAYER, pos = {50.0, 400.0}, hp = 10})
	append(&game.entities, Entity{type = .ENEMY, pos = {50.0, 50.0}, hp = 1})
	append(&game.entities, Entity{type = .ENEMY, pos = {100.0, 100.0}, hp = 1})
	append(&game.entities, Entity{type = .ENEMY, pos = {200.0, 200.0}, hp = 1})

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

			for _, i in game.entities {
				update_entity(&game.entities[i], &game)
			}

			for i := 0; i < len(game.entities); {
				if game.entities[i].hp <= 0 {
					ordered_remove(&game.entities, i)
				} else {
					i += 1
				}
			}
		}

		sdl2.SetRenderDrawColor(renderer, 0, 0, 0, 0)
		sdl2.RenderClear(renderer)
		for _, i in game.entities {
			render_entity(&game.entities[i], &game)
		}
		sdl2.RenderPresent(renderer)
	}
}

