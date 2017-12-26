# VergilPrime's Common Local Packages #

## Tools ##

### ~~-----~~ Commands ~~-----~~ ###

#### ~~---~~ Run ~~---~~ ####

##### Description: #####
Run code from in-game or console commands. Allows for easy testing of code, akin to commandhelper's interpreter mode but less restricted. Sends returned data to the command sender. VERY DANGEROUS, DO NOT GIVE ACCESS TO ANYONE OR GOD HELP YOU!

##### Usage: #####
/run <code to be evaluated>

##### Permission: #####
commandhelper.interpreter

##### Example: #####
/run set_ploc(player('verg'),array(0,100,0,'world'));


#### ~~---~~ SetTitle ~~---~~ ####

##### Description: #####
Set the display meta data for whatever item is in your hand. This uses both color codes and placeholders if the Placeholder extension is installed.

##### Usage: #####
/settitle <color coded text>

##### Permission: #####
angelsreach.tools.title

##### Example: #####
/settitle &7[&a&l%player%'s Iron Sword of Justice&7]
