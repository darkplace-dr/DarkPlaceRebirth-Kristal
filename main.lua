if OrigGlobal then
    local chunk = love.filesystem.load("src/funnymetagag.lua")
    setfenv(chunk, OrigGlobal)
    chunk()
end

require("src.engine.tweaks")

require("src.engine.vars")
require("src.engine.statevars")
require("src.engine.vendcust")

DiscordRPC = require("src.lib.discordrpc")

---@diagnostic disable-next-line: lowercase-global
https = require("src.lib.https")

---@diagnostic disable-next-line: lowercase-global
utf8 = require("utf8")

_Class = require("src.lib.hump.class")
Vector = require("src.lib.hump.vector-light")
LibTimer = require("src.lib.hump.timer")
JSON = require("src.lib.json")
Ease = require("src.lib.easing")
SemVer = require("src.lib.semver")
require("src.lib.stable_sort")

NativeFS = require("src.lib.nativefs")

Class = require("src.utils.class")
require("src.utils.graphics")

ColorUtils = require("src.utils.colorutils")
MathUtils = require("src.utils.mathutils")
StringUtils = require("src.utils.stringutils")
TableUtils = require("src.utils.tableutils")
ClassUtils = require("src.utils.classutils")
TiledUtils = require("src.utils.tiledutils")
FileSystemUtils = require("src.utils.filesystemutils")
HookSystem = require("src.utils.hooksystem")
Utils = require("src.utils.utils")

GitFinder = require("src.utils.gitfinder")
CollisionUtil = require("src.utils.collision")
Draw = require("src.utils.draw")
GeneralUtils = require("src.utils.utils_general")

Kristal = require("src.kristal")
-- Ease of access for game variables
Game = Kristal.States["Game"]
MainMenu = Kristal.States["MainMenu"]
LoadingState = Kristal.States["Loading"]

Assets = require("src.engine.assets")
Music = require("src.engine.music")
Input = require("src.engine.input")
TextInput = require("src.engine.textinput")
Registry = require("src.engine.registry")
Camera = require("src.engine.camera")

Object = require("src.engine.object")
Stage = require("src.engine.objects.stage")
Sprite = require("src.engine.objects.sprite")
Text = require("src.engine.objects.text")
DialogueText = require("src.engine.objects.dialoguetext")
Explosion = require("src.engine.objects.explosion")
AfterImage = require("src.engine.objects.afterimage")
FakeClone = require("src.engine.objects.fakeclone")
Rectangle = require("src.engine.objects.rectangle")
Ellipse = require("src.engine.objects.ellipse")
Fader = require("src.engine.objects.fader")
HPText = require("src.engine.objects.hptext")
Timer = require("src.engine.objects.timer")
StateManager = require("src.engine.objects.statemanager")
StateClass = require("src.engine.objects.stateclass")
Anchor = require("src.engine.objects.anchor")
Callback = require("src.engine.objects.callback")
Video = require("src.engine.objects.video")
GonerChoice = require("src.engine.objects.gonerchoice")
GonerKeyboard = require("src.engine.objects.gonerkeyboard")

MainMenuTitle = require("src.engine.menu.mainmenutitle")
MainMenuOptions = require("src.engine.menu.mainmenuoptions")
MainMenuCredits = require("src.engine.menu.mainmenucredits")
MainMenuModList = require("src.engine.menu.mainmenumodlist")
MainMenuModCreate = require("src.engine.menu.mainmenumodcreate")
MainMenuModConfig = require("src.engine.menu.mainmenumodconfig")
MainMenuModError = require("src.engine.menu.mainmenumoderror")
MainMenuFileSelectDark = require("src.engine.menu.mainmenufileselectdark")
MainMenuCompletionSelect = require("src.engine.menu.mainmenucompletionselect")
MainMenuFileName = require("src.engine.menu.mainmenufilename")
MainMenuDefaultName = require("src.engine.menu.mainmenudefaultname")
MainMenuControls = require("src.engine.menu.mainmenucontrols")
MainMenuDeadzone = require("src.engine.menu.mainmenudeadzone")
MainMenuDLC = require("src.engine.menu.mainmenudlc")
MainMenuWarning = require("src.engine.menu.mainmenuwarning")
MainMenuPlugins = require("src.engine.menu.mainmenuplugins")

ModList = require("src.engine.menu.objects.modlist")
ModButton = require("src.engine.menu.objects.modbutton")
DLCButton = require("src.engine.menu.objects.DLCbutton")
ModCreateButton = require("src.engine.menu.objects.modcreatebutton")
FileButton = require("src.engine.menu.objects.filebutton")
DarkFileButton = require("src.engine.menu.objects.darkfilebutton")
FileNamer = require("src.engine.menu.objects.filenamer")

DarkTransitionLine = require("src.engine.game.darktransition.darktransitionline")
DarkTransitionParticle = require("src.engine.game.darktransition.darktransitionparticle")
DarkTransitionSparkle = require("src.engine.game.darktransition.darktransitionsparkle")
HeadObject = require("src.engine.game.darktransition.head_object")

FXBase = require("src.engine.drawfx.fxbase")
ShaderFX = require("src.engine.drawfx.shaderfx")
ColorMaskFX = require("src.engine.drawfx.colormaskfx")
AlphaFX = require("src.engine.drawfx.alphafx")
RecolorFX = require("src.engine.drawfx.recolorfx")
MaskFX = require("src.engine.drawfx.maskfx")
OutlineFX = require("src.engine.drawfx.outlinefx")
OutlineFX_V2 = require("src.engine.drawfx.outlinefx_v2")
BattleOutlineFX = require("src.engine.drawfx.battleoutlinefx")
ShadowFX = require("src.engine.drawfx.shadowfx")
FountainShadowFX = require("src.engine.drawfx.fountainshadowfx")
GradientFX = require("src.engine.drawfx.gradientfx")
ScissorFX = require("src.engine.drawfx.scissorfx")
VHSFilterFX = require("src.engine.drawfx.vhsfilterfx")
PaletteFX = require("src.engine.drawfx.palettefx")
BGPaletteFX = require("src.engine.drawfx.bgpalettefx")

Collider = require("src.engine.colliders.collider")
ColliderGroup = require("src.engine.colliders.collidergroup")
Hitbox = require("src.engine.colliders.hitbox")
LineCollider = require("src.engine.colliders.linecollider")
CircleCollider = require("src.engine.colliders.circlecollider")
PointCollider = require("src.engine.colliders.pointcollider")
PolygonCollider = require("src.engine.colliders.polygoncollider")

PartyMember = require("src.engine.game.common.data.partymember")
Actor = require("src.engine.game.common.data.actor")
Spell = require("src.engine.game.common.data.spell")
Item = require("src.engine.game.common.data.item")
Badge = require("src.engine.game.common.data.badge")
HealItem = require("src.engine.game.common.data.healitem")
TeaItem = require("src.engine.game.common.data.teaitem")
TensionItem = require("src.engine.game.common.data.tensionitem")
LightEquipItem = require("src.engine.game.common.data.lightequipitem")
Recruit = require("src.engine.game.common.data.recruit")
Quest = require("src.engine.game.common.data.quest")
FallbackQuest = require("src.engine.game.common.data.fallbackquest")
ButtonPrompt = require("src.engine.game.buttonprompt")
Material = require("src.engine.game.common.data.material")

ActorSprite = require("src.engine.game.common.actorsprite")
Inventory = require("src.engine.game.common.inventory")
DarkInventory = require("src.engine.game.common.darkinventory")
LightInventory = require("src.engine.game.common.lightinventory")
LancerKeyItem = require("src.engine.game.common.lancerkeyitem")
GersonKeyItem = require("src.engine.game.common.gersonkeyitem")

Cutscene = require("src.engine.game.common.cutscene")
WorldCutscene = require("src.engine.game.world.worldcutscene")
BattleCutscene = require("src.engine.game.battle.battlecutscene")
LegendCutscene = require("src.engine.game.legend.legendcutscene")

Console = require("src.engine.game.console")
DebugSystem = require("src.engine.game.debugsystem")
ContextMenu = require("src.engine.game.contextmenu")
DebugWindow = require("src.engine.game.debugwindow")

UIBox = require("src.engine.game.common.uibox")
Textbox = require("src.engine.game.common.textbox")
Doki_Textbox = require("src.engine.game.common.doki_textbox")
Choicebox = require("src.engine.game.common.choicebox")
TextChoicebox = require("src.engine.game.common.textchoicebox")
SmallFaceText = require("src.engine.game.common.smallfacetext")
MusicLogo = require("src.engine.game.common.musiclogo")

World = require("src.engine.game.world")
Map = require("src.engine.game.world.map")
Tileset = require("src.engine.game.world.tileset")
TileLayer = require("src.engine.game.world.tilelayer")
Character = require("src.engine.game.world.character")
Follower = require("src.engine.game.world.follower")
Player = require("src.engine.game.world.player")
OverworldSoul = require("src.engine.game.world.overworldsoul")
WorldBullet = require("src.engine.game.world.worldbullet")
ChaserEnemy = require("src.engine.game.world.chaserenemy")
Nametag = require("src.engine.game.world.nametag")
InputMenu = require("src.engine.game.world.inputmenu")

Minigame = require("src.engine.game.minigames.minigame")

AngryBirds = require("src.engine.game.minigames.angrybirds.angrybirds")
AngryBirdsButton = require("src.engine.game.minigames.angrybirds.angrybirdsbutton")
AngryBirdsCredits = require("src.engine.game.minigames.angrybirds.angrybirdscredits")
AngryBirdsMainMenu = require("src.engine.game.minigames.angrybirds.angrybirdsmainmenu")
AngryBirdsPopup = require("src.engine.game.minigames.angrybirds.angrybirdspopup")
AngryBirdsUIBox = require("src.engine.game.minigames.angrybirds.angrybirdsuibox")

BallJump = require("src.engine.game.minigames.balljump.balljump")
BallJumpEntity = require("src.engine.game.minigames.balljump.balljumpentity")
BallJumpBackChuck = require("src.engine.game.minigames.balljump.balljumpbackchuck")
BallJumpBall = require("src.engine.game.minigames.balljump.balljumpball")
BallJumpBallGold = require("src.engine.game.minigames.balljump.balljumpballgold")
BallJumpBullet = require("src.engine.game.minigames.balljump.balljumpbullet")
BallJumpChuck = require("src.engine.game.minigames.balljump.balljumpchuck")
BallJumpFakeBall = require("src.engine.game.minigames.balljump.balljumpfakeball")
BallJumpFastBall = require("src.engine.game.minigames.balljump.balljumpfastball")
BallJumpFinish = require("src.engine.game.minigames.balljump.balljumpfinish")
BallJumpGoomba = require("src.engine.game.minigames.balljump.balljumpgoomba")
BallJumpPlayer = require("src.engine.game.minigames.balljump.balljumpplayer")
BallJumpSCoin = require("src.engine.game.minigames.balljump.balljumpscoin")
BallJumpSpikeF = require("src.engine.game.minigames.balljump.balljumpspikef")
BallJumpSpiny = require("src.engine.game.minigames.balljump.balljumpspiny")

PunchOut = require("src.engine.game.minigames.punchout.punchout")
PunchOutHero = require("src.engine.game.minigames.punchout.punchouthero")
PunchOutQueen = require("src.engine.game.minigames.punchout.punchoutqueen")
PunchOutHitbox = require("src.engine.game.minigames.punchout.punchouthitbox")
PunchOutWheel = require("src.engine.game.minigames.punchout.punchoutwheel")
PunchOutBaseball = require("src.engine.game.minigames.punchout.punchoutbaseball")

RareCats = require("src.engine.game.minigames.rarecats.rarecats")
RareCatsEntity = require("src.engine.game.minigames.rarecats.rarecatsentity")

SaveMenu = require("src.engine.game.world.ui.savemenu")
SimpleSaveMenu = require("src.engine.game.world.ui.simplesavemenu")
LightSaveMenu = require("src.engine.game.world.ui.lightsavemenu")
HealthBar = require("src.engine.game.world.ui.healthbar")
OverworldActionBox = require("src.engine.game.world.ui.overworldactionbox")
Shopbox = require("src.engine.game.world.ui.shopbox")
RecruitMenu = require("src.engine.game.world.ui.recruitmenu")
QuestMenu = require("src.engine.game.world.ui.questmenu")
QuestCreatedPopup = require("src.engine.game.world.ui.questcreatedpopup")

DarkMenu = require("src.engine.game.world.ui.dark.darkmenu")
DarkItemMenu = require("src.engine.game.world.ui.dark.darkitemmenu")
DarkEquipMenu = require("src.engine.game.world.ui.dark.darkequipmenu")
DarkPowerMenu = require("src.engine.game.world.ui.dark.darkpowermenu")
DarkConfigMenu = require("src.engine.game.world.ui.dark.darkconfigmenu")
DarkAPMMenu = require("src.engine.game.world.ui.dark.darkapmmenu")
DarkMenuPartySelect = require("src.engine.game.world.ui.dark.darkmenupartyselect")
DarkStorageMenu = require("src.engine.game.world.ui.dark.darkstoragemenu")
DarkBadgeMenu = require("src.engine.game.world.ui.dark.darkbadgemenu")
DarkCharacterMenu = require("src.engine.game.world.ui.dark.darkcharactermenu")
DarkPartyMenu = require("src.engine.game.world.ui.dark.darkpartymenu")

LightMenu = require("src.engine.game.world.ui.light.lightmenu")
LightItemMenu = require("src.engine.game.world.ui.light.lightitemmenu")
LightStatMenu = require("src.engine.game.world.ui.light.lightstatmenu")
LightCellMenu = require("src.engine.game.world.ui.light.lightcellmenu")

Event = require("src.engine.game.world.event")
Script = require("src.engine.game.world.events.script")
Interactable = require("src.engine.game.world.events.interactable")
Savepoint = require("src.engine.game.world.events.savepoint")
TreasureChest = require("src.engine.game.world.events.treasurechest")
Transition = require("src.engine.game.world.events.transition")
NPC = require("src.engine.game.world.events.npc")
Outline = require("src.engine.game.world.events.outline")
SlideArea = require("src.engine.game.world.events.slidearea")
Silhouette = require("src.engine.game.world.events.silhouette")
CameraTarget = require("src.engine.game.world.events.cameratarget")
HideParty = require("src.engine.game.world.events.hideparty")
SetFlagEvent = require("src.engine.game.world.events.setflagevent")
CyberTrashCan = require("src.engine.game.world.events.cybertrashcan")
Forcefield = require("src.engine.game.world.events.forcefield")
PushBlock = require("src.engine.game.world.events.pushblock")
TileButton = require("src.engine.game.world.events.tilebutton")
MagicGlass = require("src.engine.game.world.events.magicglass")
VoidGlass = require("src.engine.game.world.events.voidglass")
TileObject = require("src.engine.game.world.events.tileobject")
FrozenEnemy = require("src.engine.game.world.frozenenemy")
WarpDoor = require("src.engine.game.world.events.warpdoor")
WarpBin = require("src.engine.game.world.events.warpbin")
DarkFountain = require("src.engine.game.world.events.darkfountain")
FountainFloor = require("src.engine.game.world.events.fountainfloor")
QuicksaveEvent = require("src.engine.game.world.events.quicksave")
MirrorArea = require("src.engine.game.world.events.mirror")
SuperStar = require("src.engine.game.world.events.superstar")

ToggleController = require("src.engine.game.world.events.controllers.togglecontroller")
FountainShadowController = require("src.engine.game.world.events.controllers.fountainshadowcontroller")

Battle = require("src.engine.game.battle")
Encounter = require("src.engine.game.battle.encounter")
Wave = require("src.engine.game.battle.wave")
Battler = require("src.engine.game.battle.battler")
PartyBattler = require("src.engine.game.battle.partybattler")
EnemyBattler = require("src.engine.game.battle.enemybattler")
Arena = require("src.engine.game.battle.arena")
Soul = require("src.engine.game.battle.soul")
Bullet = require("src.engine.game.battle.bullet")
Solid = require("src.engine.game.battle.solid")
GrazeSprite = require("src.engine.game.battle.grazesprite")
ArenaSprite = require("src.engine.game.battle.arenasprite")
ArenaMask = require("src.engine.game.battle.arenamask")
SnowGraveSpell = require("src.engine.game.battle.snowgravespell")
XSlashSpell = require("src.engine.game.battle.xslashspell")
Quicktime = require("src.engine.game.battle.quicktime")
Slapper = require("src.engine.game.battle.slapper")
Combo = require("src.engine.game.battle.combo")
Mend = require("src.engine.game.battle.mend")

BlueSoul = require("src.engine.game.battle.souls.bluesoul")

BattleUI = require("src.engine.game.battle.ui.battleui")
ActionBox = require("src.engine.game.battle.ui.actionbox")
ActionBoxDisplay = require("src.engine.game.battle.ui.actionboxdisplay")
ActionButton = require("src.engine.game.battle.ui.actionbutton")
AttackBox = require("src.engine.game.battle.ui.attackbox")
AttackBar = require("src.engine.game.battle.ui.attackbar")
TensionBar = require("src.engine.game.battle.ui.tensionbar")
TensionBarGlow = require("src.engine.game.battle.ui.tensionbarglow")
SpeechBubble = require("src.engine.game.battle.ui.speechbubble")

FlashFade = require("src.engine.game.effects.flashfade")
DamageNumber = require("src.engine.game.effects.damagenumber")
RecruitMessage = require("src.engine.game.effects.recruitmessage")
HeartBurst = require("src.engine.game.effects.heartburst")
HealSparkle = require("src.engine.game.effects.healsparkle")
SpareSparkle = require("src.engine.game.effects.sparesparkle")
SpareZ = require("src.engine.game.effects.sparez")
SleepMistEffect = require("src.engine.game.effects.sleepmisteffect")
SnowglobeEffect = require("src.engine.game.effects.snowglobeeffect")
IceSpellEffect = require("src.engine.game.effects.icespelleffect")
IceSpellBurst = require("src.engine.game.effects.icespellburst")
SnowGraveSnowflake = require("src.engine.game.effects.snowgravesnowflake")
FatalEffect = require("src.engine.game.effects.fataleffect")
RudeBusterBeam = require("src.engine.game.effects.rudebusterbeam")
RudeBusterBurst = require("src.engine.game.effects.rudebusterburst")
RudeBusterBeamGreen = require("src.engine.game.effects.rudebusterbeamgreen")
RudeBusterBurstGreen = require("src.engine.game.effects.rudebusterburstgreen")
SpearBlasterBullet = require("src.engine.game.effects.spearblasterbullet")
IceBeamSpell = require("src.engine.game.effects.icebeamspell")
IceBurst = require("src.engine.game.effects.iceburst")
MirrorEffect = require("src.engine.game.effects.mirroreffect")
MultiFlareFireball = require("src.engine.game.effects.multiflarefireball")
PaciBusterBeam = require("src.engine.game.effects.pacibusterbeam")

Discoball = require("src.engine.game.battle.bg.discoball")
DojoBG = require("src.engine.game.battle.bg.dojobg")
ConcentrateBG = require("src.engine.game.battle.bg.concentratebg")

Shop = require("src.engine.game.shop")
Shopkeeper = require("src.engine.game.shop.shopkeeper")

Disconnection = require("src.engine.game.disconnection")

Border = require("src.engine.border")
ImageBorder = require("src.engine.imageborder")

GameOver = require("src.engine.game.gameover")
GameOverSF = require("src.engine.game.gameoversf")

Legend = require("src.engine.game.legend")

DogCheck = require("src.engine.game.dogcheck")


WarpBinCodes = require("src.engine.warp_bin")
WarpBinCS = require("src.engine.game.world.warp_bin_cs")


DarkTransition = require("src.engine.game.darktransition.darktransition")
LoadingDarkTransition = require("src.engine.game.darktransition.loadingdarktransition")

EasingSoul = require("src.engine.objects.easingsoul")

-- UI SYSTEM
Component = require("src.engine.ui.component")
BoxComponent = require("src.engine.ui.components.box")
MainMenuBoxComponent = require("src.engine.ui.components.mainmenubox")
SeparatorComponent = require("src.engine.ui.components.separator")
BarComponent = require("src.engine.ui.components.bar")
ScrollbarComponent = require("src.engine.ui.components.scrollbar")

AbstractMenuComponent = require("src.engine.ui.components.abstractmenu")
BasicMenuComponent = require("src.engine.ui.components.basicmenu")
EasingSoulMenuComponent = require("src.engine.ui.components.easingsoulmenu")

AbstractMenuItemComponent = require("src.engine.ui.components.abstractmenuitem")
TextMenuItemComponent = require("src.engine.ui.components.textmenuitem")
SoulMenuItemComponent = require("src.engine.ui.components.soulmenuitem")
TextInputMenuItemComponent = require("src.engine.ui.components.textinputmenuitem")
BooleanMenuItemComponent = require("src.engine.ui.components.booleanmenuitem")
ListMenuItemComponent = require("src.engine.ui.components.listmenuitem")
ArrowListMenuItemComponent = require("src.engine.ui.components.arrowlistmenuitem")
IntegerMenuItemComponent = require("src.engine.ui.components.integermenuitem")
ArrowIntegerMenuItemComponent = require("src.engine.ui.components.arrowintegermenuitem")
LabelMenuItemComponent = require("src.engine.ui.components.labelmenuitem")

Layout = require("src.engine.ui.layout")
HorizontalLayout = require("src.engine.ui.layouts.horizontal")
VerticalLayout = require("src.engine.ui.layouts.vertical")

Sizing = require("src.engine.ui.sizing")
FixedSizing = require("src.engine.ui.sizing.fixed")
FitSizing = require("src.engine.ui.sizing.fit")
FillSizing = require("src.engine.ui.sizing.fill")

Hotswapper = require("src.hotswapper")

-- Register required in the hotswapper
Hotswapper.updateFiles("required")

function love.run()
    if not love.timer then
        error("love.timer is required")
    end

    ---@diagnostic disable-next-line: undefined-field, redundant-parameter
    if love.load then love.load(love.arg.parseGameArguments(arg), arg) end

    -- We don't want the first frame's DT to include time taken by love.load.
    if love.timer then love.timer.step() end

    local accumulator = 0
    local error_result

    local function doUpdate(dt)
        -- Update pressed keys, handle key repeat
        Input.update()

        -- Process events.
        if love.event then
            love.event.pump()
            for name, a, b, c, d, e, f in love.event.poll() do
                if name == "quit" then
                    if not love.quit or not love.quit() then
                        return a or 0
                    end
                elseif name == "threaderror" then
                    error({ msg = b })
                end
                ---@diagnostic disable-next-line: undefined-field
                love.handlers[name](a, b, c, d, e, f)
            end
        end

        -- Call update
        if love.update then
            love.update(dt)
        end
    end

    local function doDraw()
        if love.graphics and love.graphics.isActive() then
            love.graphics.origin()
            love.graphics.clear(love.graphics.getBackgroundColor())

            ---@diagnostic disable-next-line: undefined-field
            if love.draw then love.draw() end

            love.graphics.present()
        end
    end

    local function mainLoop()
        local frame_skip = Kristal and Kristal.Config and Kristal.Config["frameSkip"]

        if FRAMERATE > 0 and not FAST_FORWARD then
            local tick_rate = 1 / FRAMERATE

            local dt = love.timer.step()
            accumulator = accumulator + dt

            local update = false
            while accumulator >= tick_rate do
                accumulator = accumulator - tick_rate
                update = true
            end

            FPS_TIMER = FPS_TIMER + dt
            if FPS_TIMER >= 1 then
                FPS = FPS_COUNTER
                FPS_COUNTER = 0
                FPS_TIMER = FPS_TIMER - 1
            end

            if update then
                FPS_COUNTER = FPS_COUNTER + 1
                local update_dt = tick_rate
                if frame_skip then
                    update_dt = math.min(math.max(dt, tick_rate), 1 / 20) -- Limit dt to at least 20fps if frameSkip is enabled to avoid huge breakage
                end
                local ret = doUpdate(update_dt)
                if ret then return ret end
                doDraw()
            end
        else
            -- Limit dt to 30fps (or 20fps if frameSkip is enabled)
            -- Don't want to go unlimited or else collision and other stuff might break
            local dt = math.min(love.timer.step(), frame_skip and (1 / 20) or (1 / 30))

            FPS = love.timer.getFPS()

            local ret = doUpdate(dt)
            if ret then return ret end

            doDraw()
        end
        love.timer.sleep(0.001)
    end

    -- Main loop time.
    return function ()
        if error_result then
            local result = error_result()
            if result then
                if result == "reload" then
                    Mod = nil
                    error_result = nil
                    Kristal.returnToMenu()
                else
                    if love.quit then
                        love.quit()
                    end
                    return result
                end
            end
        else
            local err_msg_expose
            local success, result = xpcall(mainLoop, 
                function(err_msg) 
                    --has a chance of failing due to a stack overflow. try and catch that, but this *also* might cause a stack overflow
                    local ok, msg = pcall(Kristal.errorHandler, err_msg, 4)
                    if(ok) then
                        return msg
                    else -- err_msg *might* contain a stack overflow error, pass it on if the kristal error handler fails
                        err_msg_expose = err_msg
                        return debug.traceback() --somehow, this affects the above if statement? im so confused but it works...doesnt send err_msg through
                    end
                end
            )
            if success then
                return result
            elseif type(result) == "function" then
                error_result = result
            else
                --this should only happen when there's an internal error with the errorhandler or the callstack overflows
                --the LUA_ERRERR state is set internally by the lua engine for both of these cases 
                --see https://www.lua.org/source/5.4/ldo.c.html
                error_result = Kristal.errorHandler({ critical = result, msg = err_msg_expose })
            end
        end
    end
end
