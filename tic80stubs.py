
def cls(color=None):
    """Clears the screen."""
    pass

def pix(x, y, color=None):
    """Sets or gets the color of a pixel at (x, y)."""
    pass

def line(x0, y0, x1, y1, color):
    """Draws a line from (x0, y0) to (x1, y1) with a specific color."""
    pass

def rect(x, y, w, h, color):
    """Draws a rectangle outline."""
    pass

def rectb(x, y, w, h, color):
    """Draws a filled rectangle."""
    pass

def circ(x, y, r, color):
    """Draws a circle outline."""
    pass

def circb(x, y, r, color):
    """Draws a filled circle."""
    pass

def spr(id, x, y, colorkey=None, scale=1, flip=0, rotate=0):
    """Draws a sprite."""
    pass

def tri(x1, y1, x2, y2, x3, y3, color):
    """Draws a triangle outline."""
    pass

def trib(x1, y1, x2, y2, x3, y3, color):
    """Draws a filled triangle."""
    pass

def map(cell_x, cell_y, width, height, screen_x, screen_y, colorkey=None, scale=1, remap=None):
    """Draws a section of the map."""
    pass

def textri(x1, y1, x2, y2, x3, y3, u1, v1, u2, v2, u3, v3, use_alpha=False):
    """Draws a textured triangle."""
    pass

def btn(index=None):
    """Checks if a button is pressed. Returns a boolean or an integer if index is None."""
    pass

def btnp(index=None):
    """Checks if a button is pressed in the current frame."""
    pass

def font(text, x, y, chromakey, charwidth, charheight, fixed=False, scale=1):
    """Print string with font defined in foreground sprites."""
    pass

def print(text, x=0, y=0, color=15, fixed=False, scale=1, smallfont=False):
    """Prints text on the screen."""
    pass

def sfx(id, note=None, octave=None, duration=None, channel=None, volume=None, speed=None):
    """Plays a sound effect."""
    pass

def music(track=-1, frame=-1, row=-1, loop=True):
    """Plays, stops, or changes the current music track."""
    pass

def peek(address):
    """Reads a byte from memory."""
    pass

def peek2(address):
    """Reads a byte from memory."""
    pass

def peek4(address):
    """Reads a byte from memory."""
    pass

def poke(address, value):
    """Writes a byte to memory."""
    pass

def poke2(address, value):
    """Writes a byte to memory."""
    pass

def poke4(address, value):
    """Writes a byte to memory."""
    pass

def memcpy(dest, src, size):
    """Copies bytes from one memory location to another."""
    pass

def memset(dest, value, size):
    """Fills memory with a value."""
    pass

def time():
    """Returns the time in seconds since the program started."""
    pass

def sync(mask=0xFFFF, bank=0, to_cart=False):
    """Synchronizes data between RAM and persistent storage."""
    pass

def reset():
    """Resets the game."""
    pass

def exit():
    """Exits the game."""
    pass

def mouse():
    """Returns the mouse's x, y position and button states."""
    pass

def clipboard(text=None):
    """Gets or sets clipboard content."""
    pass

def mget(x, y):
    """Gets the index of the tile at the specified map coordinates"""
    pass

def mset(x, y, tileID):
    """Sets the specified tile at the map coordinates to that tile"""
    pass

def trace(message, color=15):
    """Debug function, prints message to console in color"""
    pass

def key(keycode):
    """Returns if a keycode key is pressed"""
    pass