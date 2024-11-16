# patch-zip

A Bash script to patch or merge zip archives (or jar files).


## Usage

Specify the result archive as the first argument.

Then, specify every zip/jar that should be merged together.

Archives specified later replace/overwrite contents from archives specified earlier.

Example:

```bash
bash patch-zip.bash modded-game.jar game.jar mod1.zip mod2.zip
```

Contents from `mod2.zip` will always appear in `modded-game.jar`.

Contents from `mod1.zip` will appear in `modded-game.jar` if and only if contents with equivalent names do not appear in `mod2.zip`.

Contents from `game.jar` will appear in `modded-game.jar` if and only if contents with equivalent names do not appear in either `mod1.zip` or `mod2.zip`.


## Installation

Place the script somewhere in your `PATH`. Example:

```bash
# Assuming ~/.local/bin is already added to your PATH
cp patch-zip.bash ~/.local/bin/patch-zip
chmod +x ~/.local/bin/patch-zip
```

