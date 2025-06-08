import argparse

import retro
import gym
import sys
import cv2
import ctypes 
import pyglet
import time
from pyglet import gl
from pyglet.window import key as keycodes

# this program takes a command "inputs = []" as first command line argument. These are the inputs for the run.
# it executes retro on the given inputs and terminates when the run either fails, or if there are no more inputs left
# Out output is pretty simple: write the position we are executing to stdout (with a separator) and at the end write a score
# the score is formatted "score:NUM"
# the output looks like this "1|2|3|4|5|6|7|8|9|10|11|12|13|14|score:122"
# that's all relevant information needed for now


### valid actions ###
## SuperMarioBros-Nes
#   'MOTION_RIGHT', 'RIGHT'             - Right
#   'MOTION_LEFT', 'LEFT'               - Left
#   'Z'                                 - Jump
#   'X'                                 - Shoot
#   'DOWN', 'MOTION_DOWN'               - Down (Pipes)
#   'UP', 'MOTION_UP'                   - Up (Pipes)



### end conditions ###
## SuperMarioBros-Nes
#   you start with 2 lives, once they hit 1, it's considered a failure
#   info.lives = 1 -> exit

def keys_to_act(keys, env):
        inputs = {
            None: False,

            'BUTTON': 'Z' in keys,
            'A': 'Z' in keys,
            'B': 'X' in keys,

            'C': 'C' in keys,
            'X': 'A' in keys,
            'Y': 'S' in keys,
            'Z': 'D' in keys,

            'L': 'Q' in keys,
            'R': 'W' in keys,

            'UP': 'UP' in keys,
            'DOWN': 'DOWN' in keys,
            'LEFT': 'LEFT' in keys,
            'RIGHT': 'RIGHT' in keys,

            'MODE': 'TAB' in keys,
            'SELECT': 'TAB' in keys,
            'RESET': 'ENTER' in keys,
            'START': 'ENTER' in keys,
        }
        return [inputs[b] for b in env.buttons]





class thus:

    def setup(self, env, sync=True, tps=60, aspect_ratio=None):
        obs = env.reset()
        self._image = self.get_image(obs, env)
        assert len(self._image.shape) == 3 and self._image.shape[2] == 3, 'must be an RGB image'
        image_height, image_width = self._image.shape[:2]

        if aspect_ratio is None:
            aspect_ratio = image_width / image_height

        # guess a screen size that doesn't distort the image too much but also is not tiny or huge
        display = pyglet.canvas.get_display()
        screen = display.get_default_screen()
        max_win_width = screen.width * 0.9
        max_win_height = screen.height * 0.9
        win_width = image_width
        win_height = int(win_width / aspect_ratio)

        while win_width > max_win_width or win_height > max_win_height:
            win_width //= 2
            win_height //= 2
        while win_width < max_win_width / 2 and win_height < max_win_height / 2:
            win_width *= 2
            win_height *= 2

        win = pyglet.window.Window(width=win_width, height=win_height)

        self._key_handler = pyglet.window.key.KeyStateHandler()
        win.push_handlers(self._key_handler)
        win.on_close = self._on_close

        gl.glEnable(gl.GL_TEXTURE_2D)
        self._texture_id = gl.GLuint(0)
        gl.glGenTextures(1, ctypes.byref(self._texture_id))
        gl.glBindTexture(gl.GL_TEXTURE_2D, self._texture_id)
        gl.glTexParameteri(gl.GL_TEXTURE_2D, gl.GL_TEXTURE_WRAP_S, gl.GL_CLAMP)
        gl.glTexParameteri(gl.GL_TEXTURE_2D, gl.GL_TEXTURE_WRAP_T, gl.GL_CLAMP)
        gl.glTexParameteri(gl.GL_TEXTURE_2D, gl.GL_TEXTURE_MAG_FILTER, gl.GL_NEAREST)
        gl.glTexParameteri(gl.GL_TEXTURE_2D, gl.GL_TEXTURE_MIN_FILTER, gl.GL_NEAREST)
        gl.glTexImage2D(gl.GL_TEXTURE_2D, 0, gl.GL_RGBA8, image_width, image_height, 0, gl.GL_RGB, gl.GL_UNSIGNED_BYTE, None)

        self._env = env
        self._win = win

        # self._render_human = render_human
        self._key_previous_states = {}

        self._steps = 0
        self._episode_steps = 0
        self._episode_returns = 0
        self._prev_episode_returns = 0

        self._tps = tps
        self._sync = sync
        self._current_time = 0
        self._sim_time = 0
        self._max_sim_frames_per_update = 4

    def _draw(self):
        gl.glBindTexture(gl.GL_TEXTURE_2D, self._texture_id)
        video_buffer = ctypes.cast(self._image.tobytes(), ctypes.POINTER(ctypes.c_short))
        gl.glTexSubImage2D(gl.GL_TEXTURE_2D, 0, 0, 0, self._image.shape[1], self._image.shape[0], gl.GL_RGB, gl.GL_UNSIGNED_BYTE, video_buffer)

        x = 0
        y = 0
        w = self._win.width
        h = self._win.height

        pyglet.graphics.draw(
            4,
            pyglet.gl.GL_QUADS,
            ('v2f', [x, y, x + w, y, x + w, y + h, x, y + h]),
            ('t2f', [0, 1, 1, 1, 1, 0, 0, 0]),
        )

    def _on_close(self):
        self._env.close()
        sys.exit(0)

    def get_image(self, _obs, env):
        return env.render(mode='rgb_array')

    def mn(self):
        args = sys.argv[1:]
        if (len(args) != 2):
            print("unrecognized number of inputs")
            exit(1)
        # first argument is a string evaluating to a list variable "inputs"
        length = int(args[0])
        if (length <= 0):
            exit(1)
        try:
            inps = sys.stdin.read(length)
        except EOFError:
            print("EOF Error encountered")

        level = int(args[1])

        env = 0
        if (level == 0):
            env = retro.make("SuperMarioBros-Nes", state="Level1-1", scenario = None) #, use_restricted_actions=retro.Actions.DISCRETE
        elif level == 1:
            env = retro.make("SuperMarioBros-Nes", state="Level2-1", scenario = None) #, use_restricted_actions=retro.Actions.DISCRETE
        elif level == 2:
            env = retro.make("SuperMarioBros-Nes", state="Level3-1", scenario = None) #, use_restricted_actions=retro.Actions.DISCRETE
        elif level == 3:
            env = retro.make("SuperMarioBros-Nes", state="Level4-1", scenario = None) #, use_restricted_actions=retro.Actions.DISCRETE
        elif level == 4:
            env = retro.make("SuperMarioBros-Nes", state="Level5-1", scenario = None) #, use_restricted_actions=retro.Actions.DISCRETE
        elif level == 5:
            env = retro.make("SuperMarioBros-Nes", state="Level6-1", scenario = None) #, use_restricted_actions=retro.Actions.DISCRETE
        elif level == 6:
            env = retro.make("SuperMarioBros-Nes", state="Level7-1", scenario = None) #, use_restricted_actions=retro.Actions.DISCRETE
        elif level == 7:
            env = retro.make("SuperMarioBros-Nes", state="Level8-1", scenario = None) #, use_restricted_actions=retro.Actions.DISCRETE
        else:
            env = retro.make("SuperMarioBros-Nes", state=retro.State.DEFAULT, scenario = None) #, use_restricted_actions=retro.Actions.DISCRETE
        

        inputs = []
        inputs = eval(inps)
        count = 0
        done = False
        self.setup(env)
        info = {'score':0, 'lives':2}
        env.reset()

        return_primary = []
        return_secondary = []
        # iterate over the args and execute them
        for inp in inputs:
            self._win.switch_to()
            self._win.dispatch_events()
            now = time.time()

            count += 1
            #print('input: "', end="")
            #print(inp, end="")
            #print('"')
            act = keys_to_act(inp, env)
            #print(act)
            #print(count, end="")
            obs, rew, done, info = env.step(act)
            self._image = self.get_image(obs, self._env)
            self._episode_returns += rew
            self._steps += 1
            self._episode_steps += 1

            return_primary.append(self._episode_returns)
            return_secondary.append(info['score'])
    
            prev_frame_time = now
            self._draw()
            self._win.flip()
            
            if done:
                env.reset()
                break
            if (info['lives'] == 1):
                env.reset()
                break
        print("executed:", count, ":", sep="")
        #print("primaryscore:", self._episode_returns, ":", sep="")
        print("primaryscore:", end="")
        for i in range(0, len(return_primary) - 1):
            print(return_primary[i], end="|")
        if (len(return_primary) > 0):
            print(return_primary[len(return_primary) - 1], ":")
        #print("secondaryscore:", info['score'], ":", sep="")
        print("secondaryscore:", end="")
        for i in range(0, len(return_secondary) - 1):
            print(return_secondary[i], end="|")
        if (len(return_secondary) > 0):
            print(return_secondary[len(return_secondary) - 1], ":")
        if (done == True):
            exit(1)
        exit(0)

if __name__ == "__main__":
    ts = thus()
    ts.mn()



    