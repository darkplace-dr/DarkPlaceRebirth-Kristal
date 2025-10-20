<!-- Section copied verbatim from Legacy's guide -->
# Contribution Rouxls (Pronounced "Rules")
1. No NSFW, we gotta keep this mod at the very least PG-13.
2. No slurs. This one should be obvious 
3. If you're using assets that you didn't make, be sure to credit the original author(s)!
4. Don't just completely remove someone else's commit, although you can still edit what someone else has made.
5. Don't add doxxing scripts, or really any script that is dangerous to ones safety.
6. Always remember to test your commits before making a pull request. We would like to keep this mod as a bug-free experience.
7. Please don't make us add more rules like Rule 5 please.


<!-- Section adapted from Legacy's guide -->
# Official Wiki
Go to Dark Place's [official wiki](https://darkplace.wiki.gg/) and check out some stuff that has been implemented or WILL be implemented.

<!-- Section adapted from Legacy's guide -->
# Recommended Extensions for VS Code
This repo suggests installing sumneko's [Lua Language Server](https://marketplace.visualstudio.com/items?itemName=sumneko.lua), with the following configuration in `.vscode/settings.json`:

```json
{
    "Lua.runtime.version": "LuaJIT",
    "Lua.diagnostics.disable": [
        "duplicate-set-field",
        "need-check-nil",
        "undefined-global"
    ],
    "Lua.type.weakNilCheck": true,
    "Lua.type.weakUnionCheck": true,
    "Lua.runtime.builtin": {
        "utf8": "enable"
    },
    "Lua.runtime.special": {
        "modRequire": "require"
    },
    "Lua.workspace.library": [
        "${3rd}/love2d/library",
        // When making DLCs, put the full path to your Dark Place installation as a seperate entry.
    ]
}
```
<!-- TODO: Write info on setting up debugging -->
<!-- Optionally, you can also configure the repo for Local Lua Debugger. This allows for quick startup of Kristal for testing, and provides you with various debugging features, though it absolutely can reduce performance. See [this document](https://github.com/darkplace-dr/Dark-Place/blob/main/libraries/LocalLuaDebuggerIntergration/USAGE.md). -->

# Contributing to mainline

## Forking
Since Dark Place REBIRTH is, itself, a fork of Kristal, you'll need to jump through some hoops if you want to contribute to both.

### Method 1: Only Dark Place
Simply fork this repositry like any other, with the Fork button in the top-right corner of the page. If you have already forked Kristal or plan to, this won't work and you'll need to use another method.

### Method 2: Alt account
Make a seperate GitHub account and fork this repository on that new account. Optionally, give access to your main account so you don't have to bother with account switching.

### Method 3: Branching Out
This is a very complicated method, since it relies on specific Git commands. It also assumes you're familiar with the command line (on Windows, specifically Git Bash). <!-- TODO: word intro better -->

First, make sure you have a fork of *either* Kristal or DPR. I recommend forking DPR since it's easier to send a pull request to the right place.

Now, clone it locally.
```bash
git clone git@github.com:Hyperboid/Kristal-And-DPR.git DarkPlaceREBIRTH
cd DarkPlaceREBIRTH
```

Next, add the remotes.

```bash
git remote add kristal-upstream https://github.com/KristalTeam/Kristal.git
git remote add dpr-upstream https://github.com/darkplace-dr/DarkPlaceRebirth-Kristal.git
```

Then, set up the local `main` branch to track DPR.
```bash
git branch --set-upstream main dpr-upstream/main
```

As an optional step, you can enable `push.autoSetupRemote`.
```bash
git config --global push.autoSetupRemote true
```

Finally, you can create branches and send pull requests. For example:
```bash
git checkout -b dpr/greatest-branch-ever
# (Some commits)
git push
```

<!--
TODO: Tutorial for multi-worktree (where you have a Kristal and Dark place folder that both share .git to save storage)
#### Method 3a: Branch Abuse
-->

# Creating DLCs

First, create a regular Kristal mod. You can either create it within regular Kristal and move it, or run `MainMenu:setState("MODCREATE")` on the title screen. Your DLC can be developed like any other Kristal mod, but with a few extra features you get for free.

Great, you now have a DLC! But, the only way to access it is with the debug menu... That won't do. We need a way to enter it through normal gameplay.

## Adding an entrance and exit

The simplest way to connect is with the Warp Bin. Just set an entry in mod.json:
```json
    "dlc": {
        "extraBinCodes": {
            "TESTCODE": true, // Can also be a string ID of a map.
        }
    },
```
Then, in any map (ideally the starting map), place a `warpbin` event to allow you to leave.

For more complicated entrances and exits, you can make a cutscene that calls Game:swapIntoMod. For example:
```lua
-- In a cutscene in dpr_main or dpr_light:
if cutscene:choicer({"Follow", "Don't Follow"}) == 1 then
    cutscene:wait(cutscene:fadeOut())
    Game:swapIntoMod("my_dlc")
end

-- In a cutscene in my_dlc:
if cutscene:choicer({"Leave", "Don't leave"}) == 1 then
    cutscene:wait(cutscene:fadeOut())
    Game:swapIntoMod("dpr_light", "light/hometown/town_graveyard")
end
```

<!-- TODO: World map tutorial when that's actually a thing -->
