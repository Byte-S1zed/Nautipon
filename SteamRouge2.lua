from tic80stubs import *
import math
import random
import time
# title:   Nautipon
# author:  Byte_S1zed
# desc:    An Arcade Vertical Scrolling SHUMP-lite Rouge-lite
# site:    byte-s1zed.itch.io/
# license: MIT License
# version: 0.2
# script:  python

# Global Variables
PLAYER = None
CAMERA = None
CURSOR = None
TIME = 0
LEVEL = 1
STAGE = (LEVEL - 1) % 5 + 1
SCORE = 0
SCALING = math.floor(1+0.015*(LEVEL+3)**2)
SOLIDS = {1, 2, 3, 4, 5}
ENTITIES = []
COLLECTABLES = []
MAPDATA = []
CURRENTMODE = "Title"
MUSICPLAYING = False

# Run on load
def BOOT():
    global CURSOR
    random.seed(int(time.time()))
    CURSOR = Cursor()
    CURSOR.start(Vector2(88, 88))
    cls()

# Run at 60fps
def TIC():
    global TIME, MUSICPLAYING
    cls()
    if CURRENTMODE == "Title":
        TITLESCREEN()
        if not MUSICPLAYING:
            music(0, -1, -1, True, True)
            MUSICPLAYING = True
    
    if CURRENTMODE == "Instructions":
        INSTRUCTIONS()
    
    if CURRENTMODE == "Game":
        map(CAMERA.pos.x//8, CAMERA.pos.y//8, 31, 18, -(CAMERA.pos.x%8), -(CAMERA.pos.y%8))
        map(168, 0, 12, 17, 144, 0)
        PLAYER.draw()
        PLAYER.update()
        CAMERA.update()
        CAMERA.GameManager.update()
        CAMERA.UIManager.drawUI()
    
    if CURRENTMODE == "Game Over":
        GAMEOVER()
    TIME += 1

def SETFACINGDIRECTION(Object, direction):
    #Directions 0 = Up, 1 = Right, 2 = Down, 3 = Left
    if (direction == 3):
        Object.flip = 1
        if (Object is PLAYER.Object):
            Object.drawAnimation(Object.Animations[1].advanceFrame())
        else:
            Object.drawAnimation(Object.Animations[0].advanceFrame())
    else:
        Object.flip = 0
        if (direction == 1):
            if (Object is PLAYER.Object):
                Object.drawAnimation(Object.Animations[1].advanceFrame())
            else:
                Object.drawAnimation(Object.Animations[0].advanceFrame())
        else:
            Object.drawAnimation(Object.Animations[0].advanceFrame())

def RELOADMAP():
    for data in MAPDATA:
        stage, tileid, x, y = data

        if stage == STAGE:
            mset(x, y, tileid)

def STARTGAME():
    global PLAYER, CAMERA, MUSICPLAYING
    music()
    music(1, -1, -1, True, True)
    PLAYER = Player(30, 3, 1)
    PLAYER.start(Vector2((STAGE-1)*240+72, 8))
    CAMERA = Camera(Vector2((STAGE-1)*240,0),1)
    CAMERA.start()
    RELOADMAP()
    CAMERA.GameManager.swapTileWithEntity()

def RESETGAME():
    global PLAYER, CAMERA, TIME, LEVEL, STAGE, SCORE, SCALING, ENTITIES, COLLECTABLES
    PLAYER = None
    CAMERA = None
    LEVEL = 1
    STAGE = (LEVEL - 1) % 5 + 1
    SCORE = 0
    SCALING = math.floor(1+0.015*(LEVEL+3)**2)
    ENTITIES = []
    COLLECTABLES = []
    REPOPULATEMAPDATA()

def REPOPULATEMAPDATA():
    start = (STAGE - 1) * 30
    end = start + 20

    for x in range(start, end + 1):
        for y in range(135):
            tileID = mget(x, y)
            if tileID in [116, 113, 119, 121, 124, 126, 112, 77, 74, 76, 93, 94, 95, 96, 97, 73]:
                MAPDATA.append((STAGE, tileID, x, y))


def TITLESCREEN():
    map(150, 17, 30, 17)
    titleName = [334, 321, 341, 340, 329, 336, 335, 334]
    t = TIME / 30
    for i in range(len(titleName)):
        yOffset = math.sin(t + i) * 4
        spr(titleName[i], 56 + i * 16, int(24 + yOffset), 0, 2)
    
    s = 128
    for y in range(4):
        for x in range(4):
            spr(s, 104 + x * 8, 48 + y * 8, 0)
            s += 1
        s += 12
    font("START", 96, 88, 1, 0, 0)
    font("HELP", 96, 96, 1, 0, 0)
    font("QUIT", 96, 104, 1, 0, 0)
    font("@BYTE-S1Z3D", 48, 128, 1, 0, 0)
    font("2024", 152, 128, 1, 0, 0)
    CURSOR.update()

def INSTRUCTIONS():
    map(150, 34, 30, 17)
    font("INSTRUCTIONS", 72, 16, 1, 0, 0)
    font("MOVE", 56, 32, 1, 0, 0)
    font("FIRE", 56, 56, 1, 0, 0)
    font("HOOK", 56, 64, 1, 0, 0)
    font("COOLDOWN", 40, 80, 1, 0, 0)
    font("DECREASE", 40, 88, 1, 0, 0)
    font("RANGE", 152, 32, 1, 0, 0)
    font("INCREASE", 152, 40, 1, 0, 0)
    font("DAMAGE", 152, 56, 1, 0, 0)
    font("INCREASE", 152, 64, 1, 0, 0)
    font("HEALTH", 152, 80, 1, 0, 0)
    font("INCREASE", 152, 88, 1, 0, 0)
    font("SHOOT", 24, 104, 1, 0, 0)
    font("ENEMIES", 80, 104, 1, 0, 0)
    font("WITH", 144, 104, 1, 0, 0)
    font("YOUR", 184, 104, 1, 0, 0)
    font("HOOK,", 24, 112, 1, 0, 0)
    font("COLLECT", 72, 112, 1, 0, 0)
    font("TREASURES", 144, 112, 1, 0, 0)
    font("TO", 24, 120, 1, 0, 0)
    font("UPGRADE", 48, 120, 1, 0, 0)
    font("YOUR", 112, 120, 1, 0, 0)
    font("HOOK", 160, 120, 1, 0, 0)
    font("MAIN", 88, 0, 1, 0, 0)
    font("MENU", 128, 0, 1, 0, 0)

    if btn(5):
        sfx(4, "F-5", 10, 3)
        global CURRENTMODE
        CURRENTMODE = "Title"

def GAMEOVER():
    RESETGAME()
    map(150, 51, 30, 17)
    font("MAIN", 88, 0, 1, 0, 0)
    font("MENU", 128, 0, 1, 0, 0)
    gameOverName = [327, 321, 333, 325, 288, 335, 342, 325, 338]
    t = TIME / 30
    for i in range(len(gameOverName)):
        yOffset = math.sin(t + i) * 4
        spr(gameOverName[i], 56 + i * 16, int(24 + yOffset), 0, 2)
    if btn(5):
        sfx(4, "F-5", 10, 3)
        global CURRENTMODE
        CURRENTMODE = "Title"
        music()
        music(0, -1, -1, True, True)


#Game Manager class
class GameManager():
    def __init__(self):
        self.levelTransitionTime = -1
        self.levelTransitionDelay = 120

    def update(self):
        if self.levelTransitionTime > 0:
            self.levelTransitionTime -= 1
        
        if self.levelTransitionTime == 0:
            self.nextLevel()
        
        for e in ENTITIES:
            e.update()
            e.draw()
        
        for c in COLLECTABLES:
            c.draw()
    
    def startLevelTransition(self):
        self.levelTransitionTime = self.levelTransitionDelay
    
    def nextLevel(self):
        global LEVEL, STAGE, SCALING
        LEVEL += 1
        STAGE = (LEVEL - 1) % 5 + 1
        if (LEVEL > 5):
            RELOADMAP()
        SCALING = math.floor(1+0.015*(LEVEL+3)**2)
        PLAYER.Object.pos = Vector2((STAGE-1)*240+72, 8)
        CAMERA.pos = Vector2((STAGE-1)*240,0)
        self.levelTransitionTime = -1
        self.swapTileWithEntity()
    
    def swapTileWithEntity(self):
        start = (STAGE - 1) * 30
        end = start + 20

        for x in range(start, end + 1):
            for y in range(135):
                if (mget(x, y) == 116):
                    if LEVEL <= 5: MAPDATA.append((STAGE, 116, x, y))
                    Shark = Shark(30, 1, 1, 1, 100)
                    Shark.start(Vector2(x*8, y*8))
                    mset(x, y, STAGE + 16)
                if (mget(x, y) == 113):
                    if LEVEL <= 5: MAPDATA.append((STAGE, 113, x, y))
                    Turtle = Turtle(0, 1, 1, 1, 50)
                    Turtle.start(Vector2(x*8, y*8))
                    mset(x, y, STAGE + 16)
                if (mget(x, y) == 119):
                    if LEVEL <= 5: MAPDATA.append((STAGE, 119, x, y))
                    RedShark = RedShark(40, 1, 2, 2, 200)
                    RedShark.start(Vector2(x*8, y*8))
                    mset(x, y, STAGE + 16)
                if (mget(x, y) == 121):
                    if LEVEL <= 5: MAPDATA.append((STAGE, 121, x, y))
                    Squid = Squid(1, 1, 50)
                    Squid.start(Vector2(x*8, y*8))
                    mset(x, y, STAGE + 16)
                if (mget(x, y) == 124):
                    if LEVEL <= 5: MAPDATA.append((STAGE, 124, x, y))
                    Angler = Angler(20, 1, 1, 2, 100)
                    Angler.start(Vector2(x*8, y*8))
                    mset(x, y, STAGE + 16)
                if (mget(x, y) == 126):
                    if LEVEL <= 5: MAPDATA.append((STAGE, 126, x, y))
                    Shrimp = Shrimp(0, 1, 1, 1, 200)
                    Shrimp.start(Vector2(x*8, y*8))
                    mset(x, y, STAGE + 16)
                if (mget(x, y) == 112):
                    if LEVEL <= 5: MAPDATA.append((STAGE, 112, x, y))
                    Urchin = Urchin(99, 10, 1000)
                    Urchin.start(Vector2(x*8, y*8))
                    mset(x, y, STAGE + 16)
                if (mget(x, y) == 77):
                    if LEVEL <= 5: MAPDATA.append((STAGE, 77, x, y))
                    Crystal = Crystal(10)
                    Crystal.start(Vector2(x*8, y*8))
                    mset(x, y, STAGE + 16)
                if (mget(x, y) == 74):
                    if LEVEL <= 5: MAPDATA.append((STAGE, 74, x, y))
                    chestType = random.randint(0,10)
                    if (chestType == 7):
                        SilverChest = SilverChest(500)
                        SilverChest.start(Vector2(x*8, y*8))
                    else:
                        WoodChest = WoodChest(200)
                        WoodChest.start(Vector2(x*8, y*8))
                    mset(x, y, STAGE + 16)
                if (mget(x, y) == 76):
                    if LEVEL <= 5: MAPDATA.append((STAGE, 76, x, y))
                    GoldChest = GoldChest(1000)
                    GoldChest.start(Vector2(x*8, y*8))
                    mset(x, y, STAGE + 16)
                if (mget(x, y) == 93):
                    if LEVEL <= 5: MAPDATA.append((STAGE, 93, x, y))
                    HookRangeIncrease = HookRangeIncrease()
                    HookRangeIncrease.start(Vector2(x*8, y*8))
                    mset(x, y, STAGE + 16)
                if (mget(x, y) == 94):
                    if LEVEL <= 5: MAPDATA.append((STAGE, 94, x, y))
                    HookDamageIncrease = HookDamageIncrease()
                    HookDamageIncrease.start(Vector2(x*8, y*8))
                    mset(x, y, STAGE + 16)
                if (mget(x, y) == 95):
                    if LEVEL <= 5: MAPDATA.append((STAGE, 95, x, y))
                    HookCooldownDecrease = HookCooldownDecrease()
                    HookCooldownDecrease.start(Vector2(x*8, y*8))
                    mset(x, y, STAGE + 16)
                if (mget(x, y) == 96):
                    if LEVEL <= 5: MAPDATA.append((STAGE, 96, x, y))
                    HealthRestore = HealthRestore()
                    HealthRestore.start(Vector2(x*8, y*8))
                    mset(x, y, STAGE + 16)
                if (mget(x, y) == 97):
                    if LEVEL <= 5: MAPDATA.append((STAGE, 97, x, y))
                    HealthIncrease = HealthIncrease()
                    HealthIncrease.start(Vector2(x*8, y*8))
                    mset(x, y, STAGE + 16)
                if (mget(x, y) == 73):
                    if LEVEL <= 5: MAPDATA.append((STAGE, 73, x, y))
                    Invincible = Invincible()
                    Invincible.start(Vector2(x*8, y*8))
                    mset(x, y, STAGE + 16)

#UI Manager class
class UIManager():
    def __init__(self):
        self.hpbarContainer = []
        self.hpbar = []
        self.lastHP = -1
        self.upgradeCounts = {
            "HookRangeIncrease": 0,
            "HookDamageIncrease": 0,
            "HookCooldownDecrease": 0,
            "HealthIncrease": 0,
        }

    def drawUI(self):
        global SCORE
        formattedScore = f"{SCORE:06d}"
        font("SCORE:", 152, 8, 1, 0, 0)
        font(formattedScore, 168, 16, 1, 0, 0)
        font("AIR:", 152, 40, 1, 0, 0)
        self.HPBar()
        font("UPGRADES:", 152, 72, 1, 0, 0)
        font(f"{self.upgradeCounts['HookRangeIncrease']:02d}", 160, 88, 1, 0, 0)
        font(f"{self.upgradeCounts['HookDamageIncrease']:02d}", 160, 104, 1, 0, 0)
        font(f"{self.upgradeCounts['HookCooldownDecrease']:02d}", 160, 120, 1, 0, 0)
        font(f"{self.upgradeCounts['HealthIncrease']:02d}", 208, 88, 1, 0, 0)

    
    def HPBar(self):
        if not self.hpbarContainer:
            self.hpbarContainer.append(Object(80, Vector2(160,48), 0, 0))

            for h in range(min(PLAYER.maxHP - 2, 6)):
                self.hpbarContainer.append(Object(81, Vector2(168 + 8 * h,48), 0, 0))
            self.hpbarContainer.append(Object(82, Vector2(168 + 8 * min(PLAYER.maxHP - 2, 6),48), 0, 0))
        
        if PLAYER.hp != self.lastHP:
            self.lastHP = PLAYER.hp
            self.hpbar.clear()

            fullHealth = min(PLAYER.hp, 16)

            for p in range(min(fullHealth, 8)):
                self.hpbar.append(Object(83, Vector2(160 + 8 * p,48), 0, 0))
            if fullHealth > 8:
                for p in range(max(0, fullHealth - 8)):
                    self.hpbar.append(Object(84, Vector2(160 + 8 * p,48), 0, 0))
        
        for section in self.hpbar:
            section.drawUI()
        for secionContainer in self.hpbarContainer:
            secionContainer.drawUI()
    
    def collectUpgrade(self, upgradeName):
        if upgradeName in self.upgradeCounts:
            self.upgradeCounts[upgradeName] += 1

class Cursor():
    def __init__(self):
        self.Object = None
        self.isPressed = False
        self.cooldown = 20
        self.timer = -1
        self.lastButtonPressed = -1
        self.menuOptions = [88, 96, 104]
        self.currentIndex = 0
        self.menuActions = [self.startGame, self.instructions, self.quitGame]
    
    def start(self, pos):
        self.Object = Object(6, pos, 0, 0)
        self.Object.Animations = []
        self.Object.Animations.append(Animation([6,7], 15))
        self.Object.pos.y = self.menuOptions[self.currentIndex]
    
    def update(self):
        if self.timer > 0:
            self.timer -= 1
        else:
            self.isPressed = False
        
        if btn(0) and self.lastButtonPressed != 0:
            sfx(4, "F-5", 10, 3)
            self.isPressed = True
            self.currentIndex = (self.currentIndex - 1) % len(self.menuOptions)
            self.Object.pos.y = self.menuOptions[self.currentIndex]
            self.timer = self.cooldown
            self.lastButtonPressed = 0
        elif btn(1) and self.lastButtonPressed != 1:
            sfx(4, "F-5", 10, 3)
            self.isPressed = True
            self.currentIndex = (self.currentIndex + 1) % len(self.menuOptions)
            self.Object.pos.y = self.menuOptions[self.currentIndex]
            self.timer = self.cooldown
            self.lastButtonPressed = 1
        elif not btn(0) and not btn(1):
            self.lastButtonPressed = -1
        
        if btn(4):
            sfx(4, "F-5", 10, 3)
            self.menuActions[self.currentIndex]()
        
        self.draw()

    def draw(self):
        self.Object.drawUIAnimation(self.Object.Animations[0].advanceFrame())
    
    def startGame(self):
        global CURRENTMODE
        CURRENTMODE = "Game"
        STARTGAME()

    def instructions(self):
        global CURRENTMODE
        CURRENTMODE = "Instructions"
        pass

    def quitGame(self):
        exit()

        

#Default object class
class Object():
    def __init__(self, sprite, pos, flip, rotation):
        self.sprite = sprite
        self.pos = pos
        self.vel = Vector2(0, 0)
        self.flip = flip
        self.rotation = rotation
        self.direction = 0
        self.Animations = None
        self.Collider = Collider(self, True)
    
    def update(self):
        self.Collider.collide()
        
        if (self is PLAYER.Object):
            self.pos.x += self.vel.x
            self.pos.y += self.vel.y
        else:
            if (TIME % 2 == 0):
                self.pos.x += self.vel.x
                self.pos.y += self.vel.y
    
    def draw(self):
        spr(self.sprite, self.pos.x - CAMERA.pos.x, self.pos.y - CAMERA.pos.y, 0, 1, self.flip, self.rotation)
    
    def drawUI(self):
        spr(self.sprite, self.pos.x, self.pos.y, 0, 1, self.flip, self.rotation)

    def drawAnimation(self, animation):
        spr(animation, self.pos.x - CAMERA.pos.x, self.pos.y - CAMERA.pos.y, 0, 1, self.flip, self.rotation)
    
    def drawUIAnimation(self, animation):
        spr(animation, self.pos.x, self.pos.y, 0, 1, self.flip, self.rotation)

#Collision checking class
class Collider():
    def __init__(self, parent, isCollider):
        self.parent = parent #Object
        self.isCollider = isCollider
    
    def isSolidTileHere(self, x, y):
        tile = mget((x)//8,(y)//8)
        return tile in SOLIDS
    
    def collide(self):
        px, py, pvx, pvy = self.parent.pos.x, self.parent.pos.y, self.parent.vel.x, self.parent.vel.y

        if (self.isSolidTileHere(px + pvx, py) or self.isSolidTileHere(px+7+pvx, py) \
            or self.isSolidTileHere(px + pvx, py + 7) or self.isSolidTileHere(px+7+pvx, py+7)):
            self.parent.vel.x = 0
        
        if (self.isSolidTileHere(px, py+pvy) or self.isSolidTileHere(px+7, py+pvy) \
            or self.isSolidTileHere(px, py+7+pvy) or self.isSolidTileHere(px+7, py+7+pvy)):
            self.parent.vel.y = 0
        
        for other in ENTITIES: #Other is the higher up class, ex Shark
            if other.Object is not self.parent:
                if self.entityCollide(other.Object):
                    if (self.parent is PLAYER.Object):
                        PLAYER.takeDamage(other.damage)
        
        for other in COLLECTABLES[:]:
            if other.Object is not self.parent:
                if self.entityCollide(other.Object):
                    if (self.parent is PLAYER.Object):
                        if isinstance(other, (WoodChest, SilverChest, GoldChest)):
                            sfx(8, "C-6", 25, 3)
                            other.destroy()
                        elif isinstance(other, (HookCooldownDecrease, HookDamageIncrease, HookRangeIncrease, HealthIncrease, HealthRestore, Invincible)):
                            if not isinstance(other, (HealthRestore, Invincible)):
                                CAMERA.UIManager.collectUpgrade(f"{type(other).__name__}")
                            PLAYER.collectUpgrade(other)
                            other.destroy()
                        else:
                            PLAYER.collectPoints(other.points)
                            other.destroy()

    def entityCollide(self, other):
        px, py, ox, oy = self.parent.pos.x, self.parent.pos.y, other.pos.x, other.pos.y
        return px < ox + 8 and px + 8 > ox and py < oy + 8 and py + 8 > oy


#Camera class
class Camera():
    def __init__(self, pos, scrollSpeed):
        self.pos = pos
        self.scrollSpeed = scrollSpeed
        self.isScrolling = True
        self.GameManager = None
        self.UIManager = None
    
    def start(self):
        self.GameManager = GameManager()
        self.UIManager = UIManager()

    def update(self):
        if (TIME % 4 == 0 and self.isScrolling and CAMERA.pos.y <= 935):
            self.pos.y += self.scrollSpeed
    
    def pauseScrolling(self):
        self.isScrolling = False
    
    def resumeScrolling(self, speed = 1):
        self.isScrolling = True
        self.scrollSpeed = speed

#Player class
class Player():
    def __init__(self, hookDistance, hp, damage):
        self.Object = None
        self.Hook = None
        self.hookDistance = hookDistance
        self.hp = hp
        self.maxHP = hp
        self.damage = damage
        self.canAttack = True
        self.iframeTimer = 0
        self.iframes = 60
        self.hookCooldownTimer = 0
        self.hookCooldown = 40
        self.levelComplete = False

    def start(self, pos):
        self.Object = Object(65, pos, 0, 0)
        self.Object.Animations = []
        self.Object.Animations.append(Animation([65,66], 15))
        self.Object.Animations.append(Animation([67,68], 15))
    
    def update(self):
        if self.iframeTimer > 0:
            self.iframeTimer -= 1

        if self.hookCooldownTimer > 0:
            self.hookCooldownTimer -= 1
        
        if self.hp <= 0:
            self.die()

        if (self.Object.pos.y <= CAMERA.pos.y):
            self.Object.pos.y = CAMERA.pos.y
        elif (self.Object.pos.y >= CAMERA.pos.y+128):
            self.Object.pos.y = CAMERA.pos.y+128
        self.controls()
    
    def isInvincible(self):
        return self.iframeTimer > 0
    
    def takeDamage(self, damage):
        if not self.isInvincible():
            self.hp -= damage
            self.iframeTimer = self.iframes
            sfx(1, "C-4", 10, 3)

    def collectPoints(self, points):
        global SCORE
        SCORE += points
    
    def collectUpgrade(self, upgrade):
        upgrade.applyEffect(self)

    def draw(self):
        if (self.Hook):
            self.Hook.draw()
        SETFACINGDIRECTION(self.Object, self.Object.direction)

    def attack(self):
        if not self.Hook and self.canAttack and self.hookCooldownTimer == 0:
            start = Vector2(self.Object.pos.x, self.Object.pos.y)
            if (self.Object.direction == 0): start.y -= 8
            elif (self.Object.direction == 1): start.x += 8
            elif (self.Object.direction == 2): start.y += 8
            elif (self.Object.direction == 3): start.x -= 8

            self.Hook = Hook(start, self.Object.direction, self.hookDistance)
            if self.hookCooldown <= 0:
                self.canAttack = True
            else:
                self.canAttack = False
            self.hookCooldownTimer = self.hookCooldown
    
    def die(self):
        global CURRENTMODE
        CURRENTMODE = "Game Over"
        music()
        music(2, -1, -1, False, True)
        CAMERA.GameManager.nextLevel()
    
    def controls(self):
        global PLAYER
        if (btn(0)): 
            self.Object.vel.y = -1
            self.Object.direction = 0
        elif (btn(1)): 
            self.Object.vel.y = 1
            self.Object.direction = 2
        else:
            self.Object.vel.y = 0
        if (btn(2)): 
            self.Object.vel.x = -1
            self.Object.direction = 3
        elif (btn(3)): 
            self.Object.vel.x = 1
            self.Object.direction = 1
        else:
            self.Object.vel.x = 0
        if (btn(4) and self.canAttack):
            self.attack()
        if not (btn(4)):
            self.canAttack = True
        self.Object.update()

        if (self.Hook):
            self.Hook.update()
            if (self.Hook.isDone):
                self.Hook = None

#Hook class
class Hook():
    def __init__(self, startPos, direction, distance):
        self.Object = Object(70, Vector2(startPos.x, startPos.y), 0, direction)
        self.direction = direction
        self.distance = distance
        self.traveledDistance = 0
        self.isDone = False
        self.initPlayerPos = Vector2(PLAYER.Object.pos.x, PLAYER.Object.pos.y)

        if (self.direction == 0): self.Object.vel = Vector2(0, -3)
        elif (self.direction == 1): self.Object.vel = Vector2(3, 0)
        elif (self.direction == 2): self.Object.vel = Vector2(0, 3)
        elif (self.direction == 3): self.Object.vel = Vector2(-3, 0)

    def checkCollision(self):
        for other in ENTITIES:
            if self.Object.Collider.entityCollide(other.Object):
                self.handleCollision(other)
                self.isDone = True
                return

    def handleCollision(self, other):
        global SCORE
        other.hp -= PLAYER.damage
        sfx(2, "C-4", 10, 3)

        if other.hp <= 0:
            SCORE += other.points
            other.destroy()
    
    def update(self):
        if (self.isDone): return

        playerMovement = Vector2(PLAYER.Object.pos.x - self.initPlayerPos.x, PLAYER.Object.pos.y - self.initPlayerPos.y)
        self.Object.pos.x += playerMovement.x
        self.Object.pos.y += playerMovement.y

        self.initPlayerPos = Vector2(PLAYER.Object.pos.x, PLAYER.Object.pos.y)

        self.checkCollision()


        if (TIME % 2 == 0):
            self.Object.update()
            self.traveledDistance += abs(self.Object.vel.x) + abs(self.Object.vel.y)

        if (self.traveledDistance >= self.distance or (self.Object.vel.x == 0 and self.Object.vel.y == 0)):
            self.isDone = True

    def draw(self):
        px, py = PLAYER.Object.pos.x - CAMERA.pos.x + 4, PLAYER.Object.pos.y - CAMERA.pos.y + 4
        hx, hy = self.Object.pos.x - CAMERA.pos.x + 4, self.Object.pos.y - CAMERA.pos.y + 4
        line(px, py, hx, hy, 7)
        line(px-1, py-1, hx-1, hy-1, 7)
        self.Object.draw()

#Shark class
class Shark():
    def __init__(self, chaseRange, speed, hp, damage, points):
        self.chaseRange = chaseRange
        self.speed = speed
        self.satisfiedRange = 3
        self.hp = hp * SCALING
        self.damage = damage * SCALING
        self.points = points
        self.Object = None
        self.TailObject = None
        self.Actions = None
    
    def start(self, pos):
        self.Object = Object(116, pos, 0, 0)
        self.TailObject = Object(115, Vector2(pos.x-8, pos.y), 0, 0)
        self.TailObject.Collider = None
        self.Actions = Actions(self)
        self.Object.Animations = []
        self.Object.Animations.append(Animation([116,117], 15))
        ENTITIES.append(self)
    
    def update(self):
        if self.hp <= 0:
            self.destroy()
            return
        
        dx = PLAYER.Object.pos.x - self.Object.pos.x
        dy = PLAYER.Object.pos.y - self.Object.pos.y
        distance = self.Object.pos.distance(PLAYER.Object.pos)
        if (distance <= self.chaseRange and distance >= self.satisfiedRange and distance != 0):
            self.Actions.chase(dx, dy, distance, self.speed)
        else:
            self.Actions.wander(self.speed)
    
    def destroy(self):
        if self in ENTITIES:
            ENTITIES.remove(self)
        self.Object = None
        self.TailObject = None
    
    def draw(self):
        SETFACINGDIRECTION(self.Object, self.Object.direction)
        if (self.TailObject != None):
            self.updateTail()
            self.TailObject.draw()
    
    def updateTail(self):
        if (self.Object.vel.x < 0):
            self.TailObject.pos = Vector2(self.Object.pos.x + 8, self.Object.pos.y)
            self.TailObject.flip = 1
            self.Object.direction = 3
        else:
            self.TailObject.pos = Vector2(self.Object.pos.x - 8, self.Object.pos.y)
            self.TailObject.flip = 0
            self.Object.direction = 1

#Red Shark class
class RedShark(Shark):
    def start(self, pos):
        self.Object = Object(119, pos, 0, 0)
        self.TailObject = Object(118, Vector2(pos.x-8, pos.y), 0, 0)
        self.Actions = Actions(self)
        self.Object.Animations = []
        self.Object.Animations.append(Animation([119,120], 15))
        ENTITIES.append(self)

#Angler class
class Angler(Shark):
    def start(self, pos):
        self.Object = Object(124, pos, 0, 0)
        self.Actions = Actions(self)
        self.Object.Animations = []
        self.Object.Animations.append(Animation([124,125], 15))
        ENTITIES.append(self)
    
    def update(self):
        dx = PLAYER.Object.pos.x - self.Object.pos.x
        dy = PLAYER.Object.pos.y - self.Object.pos.y
        distance = self.Object.pos.distance(PLAYER.Object.pos)
        if (distance <= self.chaseRange and distance >= self.satisfiedRange and distance != 0):
            self.Actions.chase(dx, dy, distance, self.speed)
        else:
            self.Actions.floating()

#Shrimp class
class Shrimp(Shark):
    def start(self, pos):
        self.Object = Object(126, pos, 0, 0)
        self.Actions = Actions(self)
        self.Object.Animations = []
        self.Object.Animations.append(Animation([126,127], 15))
        ENTITIES.append(self)
    
    def update(self):
        dx = self.Object.pos.x - PLAYER.Object.pos.x
        dy = self.Object.pos.y - PLAYER.Object.pos.y
        distance = self.Object.pos.distance(PLAYER.Object.pos)
        if (distance <= self.chaseRange and distance >= self.satisfiedRange and distance != 0):
            self.Actions.chase(dx, dy, distance, self.speed)
        else:
            self.Actions.floating()

#Turtle class
class Turtle(Shark):
    def start(self, pos):
        self.Object = Object(113, pos, 0, 0)
        self.Actions = Actions(self)
        self.Object.Animations = []
        self.Object.Animations.append(Animation([113,114], 15))
        ENTITIES.append(self)
    
    def update(self):
        if (TIME % 3 == 0):
            self.Actions.wander(self.speed)

#Squid class
class Squid():
    def __init__(self, hp, damage, points):
        self.Object = None
        self.HeadObject = None
        self.Actions = None
        self.hp = hp * SCALING
        self.damage = damage * SCALING
        self.points = points

    def start(self, pos):
        self.Object = Object(122, pos, 0, 0)
        self.HeadObject = Object(121, Vector2(pos.x, pos.y-8), 0, 0)
        self.HeadObject.Collider = None
        self.Actions = Actions(self)
        self.Object.Animations = []
        self.Object.Animations.append(Animation([122,123], 15))
        ENTITIES.append(self)
    
    def update(self):
        if self.hp <= 0:
            self.destroy()
            return
        
        self.Actions.floating()
        if (self.HeadObject != None):
            self.updateHead()
            self.HeadObject.draw()

    def destroy(self):
        if self in ENTITIES:
            ENTITIES.remove(self)
        self.Object = None
        self.HeadObject = None

    def draw(self):
        SETFACINGDIRECTION(self.Object, self.Object.direction)
    
    def updateHead(self):
        self.HeadObject.pos.y = self.Object.pos.y - 8

#Urchin class
class Urchin(Squid):
    def start(self, pos):
        self.Object = Object(112, pos, 0, 0)
        self.Actions = Actions(self)
        ENTITIES.append(self)
    
    def draw(self):
        self.Object.draw()

#Crystal class
class Crystal():
    def __init__(self, points):
        self.points = points
        self.Object = None
    
    def start(self, pos):
        self.Object = Object(77, pos, 0, 0)
        self.Object.Animations = []
        self.Object.Animations.append(Animation([77], 15))
        COLLECTABLES.append(self)
    
    def destroy(self):
        sfx(12, "F-6", 10, 3)
        if self in COLLECTABLES:
            COLLECTABLES.remove(self)
        self.Object = None
    
    def draw(self):
        self.Object.draw()

#Chest classes
class WoodChest():
    def __init__(self, points):
        self.points = points
        self.Object = None

    def start(self, pos):
        self.Object = Object(74, pos, 0, 0)
        COLLECTABLES.append(self)
    
    def draw(self):
        self.Object.draw()
    
    def destroy(self):
        if self in COLLECTABLES:
            COLLECTABLES.remove(self)
        
        if (random.randint(0, 100) <= 5):
            self.spawn_upgrade(self.Object.pos)
        else:
            PLAYER.collectPoints(self.points)
        self.Object = None
    
    def spawn_upgrade(self, pos):
        upgrades = [HookRangeIncrease, HookDamageIncrease, HookCooldownDecrease, HealthRestore, HealthIncrease]
        upgrade_class = random.choice(upgrades)
        upgrade = upgrade_class()
        upgrade.start(pos)

class SilverChest(WoodChest):
    def start(self, pos):
        self.Object = Object(75, pos, 0, 0)
        COLLECTABLES.append(self)
    
    def destroy(self):
        if self in COLLECTABLES:
            COLLECTABLES.remove(self)
        
        if (random.randint(0, 100) <= 50):
            self.spawn_upgrade(self.Object.pos)
        else:
            PLAYER.collectPoints(self.points)
        self.Object = None

class GoldChest(WoodChest):
    def start(self, pos):
        self.Object = Object(76, pos, 0, 0)
        COLLECTABLES.append(self)
    
    def destroy(self):
        if self in COLLECTABLES:
            COLLECTABLES.remove(self)
        
        self.spawn_upgrade(self.Object.pos)

        CAMERA.GameManager.startLevelTransition()
        self.Object = None

#Upgrade classes
class HookRangeIncrease():
    def __init__(self):
        self.Object = None
    
    def start(self, pos):
        self.Object = Object(93, pos, 0, 0)
        COLLECTABLES.append(self)
    
    def draw(self):
        self.Object.draw()
    
    def destroy(self):
        if self in COLLECTABLES:
            COLLECTABLES.remove(self)
        self.Object = None
    
    def applyEffect(self, player):
        player.hookDistance += 2

class HookDamageIncrease(HookRangeIncrease):
    def start(self, pos):
        self.Object = Object(94, pos, 0, 0)
        COLLECTABLES.append(self)
    
    def applyEffect(self, player):
        player.damage += 1

class HookCooldownDecrease(HookRangeIncrease):
    def start(self, pos):
        self.Object = Object(95, pos, 0, 0)
        COLLECTABLES.append(self)
    
    def applyEffect(self, player):
        player.hookCooldown -= 2

class HealthRestore():
    def __init__(self):
        self.Object = None
    
    def start(self, pos):
        self.Object = Object(96, pos, 0, 0)
        COLLECTABLES.append(self)

    def draw(self):
        self.Object.draw()
    
    def destroy(self):
        if self in COLLECTABLES:
            COLLECTABLES.remove(self)
        self.Object = None
    
    def applyEffect(self, player):
        restoreAmount = max(math.floor(player.maxHP * 0.1), 1)
        player.hp = min(player.hp + restoreAmount, player.maxHP)

class HealthIncrease():
    def __init__(self):
        self.Object = None

    def start(self, pos):
        self.Object = Object(97, pos, 0, 0)
        COLLECTABLES.append(self)
    
    def draw(self):
        self.Object.draw()
    
    def destroy(self):
        if self in COLLECTABLES:
            COLLECTABLES.remove(self)
        self.Object = None

    def applyEffect(self, player):
        player.maxHP += 1
        player.hp += 1
        CAMERA.UIManager.hpbarContainer.clear()

class Invincible():
    def __init__(self):
        self.Object = None
    
    def start(self, pos):
        self.Object = Object(73, pos, 0, 0)
        COLLECTABLES.append(self)
    
    def draw(self):
        self.Object.draw()
    
    def destroy(self):
        if self in COLLECTABLES:
            COLLECTABLES.remove(self)
        self.Object = None
    
    def applyEffect(self, player):
        invincibleDuration = 180
        player.iframeTimer = max(player.iframeTimer, invincibleDuration)

#Actions class
class Actions():
    def __init__(self, parent):
        self.Parent = parent
        self.originalpos = Vector2(parent.Object.pos.x, parent.Object.pos.y)
        self.isLunging = False
        self.lungeDirection = None

    def chase(self, dx, dy, distance, speed):
        dx /= distance
        dy /= distance
        if (dx < 0): self.Parent.Object.vel.x=math.floor(dx*speed)
        else: self.Parent.Object.vel.x=math.ceil(dx*speed)
        if (dy < 0): self.Parent.Object.vel.y=math.floor(dy*speed)
        else: self.Parent.Object.vel.y=math.ceil(dy*speed)
        self.Parent.Object.update()


    def wander(self, speed):
        pvx = self.Parent.Object.vel.x
        self.Parent.Object.vel.y = 0

        if (pvx < 0):
            self.Parent.Object.direction = 3
        else:
            self.Parent.Object.direction = 1

        collider = self.Parent.Object.Collider
        px, py = self.Parent.Object.pos.x, self.Parent.Object.pos.y

        if (pvx < 0):
            if (collider.isSolidTileHere(px - 1, py) or collider.isSolidTileHere(px - 1, py + 7)):
                self.Parent.Object.vel.x = speed
        elif (pvx > 0):
            if (collider.isSolidTileHere(px + 8, py) or collider.isSolidTileHere(px + 8, py + 7)):
                self.Parent.Object.vel.x = -speed

        if (self.Parent.Object.vel.x == 0):
            self.Parent.Object.vel.x = speed
        
        self.Parent.Object.update()

    def floating(self):
        floatOffset = int(2 * math.sin(TIME * 0.1))
        self.Parent.Object.pos.y = self.originalpos.y + floatOffset

#Vector2 class
class Vector2():
    def __init__(self, x, y):
        self.x = x;
        self.y = y;

    def distance(self, other):
        return math.sqrt((self.x - other.x)**2 + (self.y - other.y)**2)

#Animation class
class Animation():
    def __init__(self, sprites, frameLength):
        self.sprite = sprites[0]
        self.sprites = sprites
        self.frameLength = frameLength
        self.currentFrame = 0
    
    def advanceFrame(self):
        if (TIME % self.frameLength == 0):
            self.currentFrame = (self.currentFrame + 1) % len(self.sprites)
        return self.sprites[self.currentFrame]