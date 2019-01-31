# chimera-trimmings

Custom settings and aliases for UCSF Chimera.

Put `chimera_aliases.com` somehere on your system and specify it as a file to read at startup (Favorites...Preferences...Command Line).

Adds a bunch of extra commands of variable utility (read the script to see them all).

I like `symclip` - to symmetrically clip with respect to the center of rotation, `cootmode` to make a Coot-like density representation for the specified volume, and `cofron` to make moving/rotating more Coot-like, and `centersel`, which moves the center of rotation to the current selection.

`local_diff_map` calulates a difference map by locally aligning and then subtracting density within a specified distance of the selected atoms.

`local_fitmap` (usage: local_fitmap #mapid1 #mapid2 raidus) aligns map 1 to a sphere of density of the specified radius centered on the current center of rotation extracted from map 2. Useful for locally comparing 3D classes.

`display_only` (usage: display_only #modelid) will display only the indicated model and hide everything else.

`display_all` will display all models

`activate_only` (usage: activate_only modelid) will activate indicated model for motion and deactivate everything else. Absence of "#" before modelid is intended.

`activate_all` will activate all models for motion.


