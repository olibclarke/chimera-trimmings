open ~/Dropbox/chimera_startup/chimera_commands.py
open ~/Dropbox/chimera_startup/setzoom.py
#Custom ryr colors

colordef ntda "navy blue"
colordef ntdb "cyan"
colordef nsol "dodger blue"
colordef spry1 "deep pink"
colordef ry12 "rosy brown"
colordef spry2 "dark magenta"
colordef spry3 "purple"
colordef jsol "dark slate gray"
colordef bsol "spring green"
colordef fkbp "chartreuse"
colordef ry34 "dark cyan"
colordef csol "khaki"
colordef ef12 "coral"
colordef taf "gold"
colordef pvsd "orange"
colordef pore "red"
colordef ctd "dark red"
colordef invisible 0 0 0 0
colordef transparent 0 0 0 0
colordef dattilo "#F1A758"
colordef charcoal "#2f682f682f68"

#Pride rainbow
alias ^pride_rainbow rainbow "#BC00FF","#4A0082","#0000FF","#128301","#FFFF0B","#FE5E06","#FD0006"

alias ^color_by_hydrophobicity color orange red :cys,ile,leu,val,tyr,met,phe,trp,ala&$1; color cornflower blue :ser,asn,gln,his,arg,lys,glu,asp,thr&$1; color green :pro&$1; color magenta :gly&$1; color gray :unk&$1; color gray ~protein&$1

alias ^sel_incomplete runscript ~/Dropbox/chimera_startup/findIncomplete.py

alias ^pride_rainbow_helix rainbow helix "#BC00FF","#4A0082","#0000FF","#128301","#FFFF0B","#FE5E06","#FD0006" 

#Normalizes map to rms and changes to blue mesh.
#Usage: normalize_to_rms #map_id_in #map_id_out
alias ^normalize_to_rms vop scale $1 rms 1 modelID $2; close $1; volume $2 capfaces false style mesh meshlighting false squaremesh false level 1 color #000000004bda; sop cap off; set depthCue; set dcStart 0.2; set dcEnd 1

#Normalizes map to rms and sets two contours, -3Xrms (red mesh) and 3Xrms (green mesh)
#Usage: split_diff_map #map_id_in #map_id_out
alias ^split_diff_map vop scale $1 rms 1 modelID $2; close $1; volume $2 capfaces false style mesh meshlighting false squaremesh false level -3 color #da1200000000 level 3 color #0000bda00000; sop cap off; set depthCue; set dcStart 0.2; set dcEnd 1

#Helix, strand and coil assign the secondary structure of the current selection as indicated.
alias ^helix setattr r isHelix true sel; setattr r isSheet false sel
alias ^strand setattr r isHelix false sel; setattr r isSheet true sel
alias ^coil setattr r isHelix false sel; setattr r isSheet false sel

#Assigns ramachandran probability to B-factor column (requires additional python script)
alias ^rama2bfac ramachandran assign $1 ; setattr r ramaProb 1.0 :/^ramaProb ; open ~/Dropbox/chimera_startup/b_fac2rama.py

#Fits selection to map.
#Usage: fitsel #map_id
alias ^fitsel fitmap sel $1 movewholemolecules false

#Fits each domain of ryr to a map.
#Usage: fit_ryr #map_id #model_id
alias ^fit_ryr fitmap :1-2144&$2&:.B $1 movewholemolecules false ; fitmap :2145-3613&:.B&$2 $1 movewholemolecules false ; fitmap :2145-2710&:.B&$2 $1 movewholemolecules false ; fitmap :2942-3613&:.B&$2 $1 movewholemolecules false ; fitmap :1-628&:.B&$2 $1 movewholemolecules false ; fitmap :629-1656&:.B&$2 $1 movewholemolecules false ; fitmap :1657-2144&:.B&$2 $1 movewholemolecules false ; fitmap :1-392&:.B&$2 $1 movewholemolecules false ; fitmap :394-628&:.B&$2 $1 movewholemolecules false ; fitmap :852-1055&:.B&$2 $1 movewholemolecules false ; fitmap :3614-4176&:.B&$2 $1 movewholemolecules false ; fitmap :4177-4253&:.B&$2 $1 movewholemolecules false ; fitmap :4063-4135&:.B&$2 $1 movewholemolecules false ; fitmap :zn|:atp|:ca|:4540-&:.B&$2 $1 movewholemolecules false; fitmap :4540-4819&:.B&$2 $1 movewholemolecules false ; fitmap :4662-4786&:.B&$2 $1 movewholemolecules false ; fitmap :4820-4933&:.B&$2 $1 movewholemolecules false ; fitmap :zn|:atp|:ca|:4934-&:.B&$2 $1 movewholemolecules false ; fitmap :zn|:atp|:ca|:4957-&:.B&$2 $1 movewholemolecules false ; fitmap :.A&$2 $1 movewholemolecules false

#Makes colored molmaps and specified resolution for each ryr domain.
#Usage: ryr_molmap #model_id resolution
alias ^ryr_molmap molmap :1-209&:.B&$1 $2 gridspacing 2 modelid $1.1 ; color cornflower blue $1.1 ; setattr M name NTD-A $1.1 ; molmap :210-393&:.B&$1 $2 gridspacing 2 modelid $1.2 ; color medium blue $1.2 ; setattr M name NTD-B $1.2 ; molmap :394-628&:.B&$1 $2 gridspacing 2 modelid $1.3 ; setattr M name NTD-C $1.3 ; color navy blue $1.3 ; molmap :629-1656&:.B&$1&~:850-1055 $2 gridspacing 2 modelid $1.4 ; setattr M name SPRY123 $1.4 ; color cyan $1.4 ; molmap :850-1055&:.B&$1 $2 gridspacing 2 modelid $1.5 ;setattr M name RY12 $1.5 ; color dark slate gray $1.5 ; molmap :1657-2144&:.B&$1 $2 gridspacing 2 modelid $1.6 ; setattr M name JSol $1.6 ; color khaki $1.6 ; molmap :2145-3613&:.B&$1&~:2734-2939 $2 gridspacing 2 modelid $1.7 ; setattr M name BSol $1.7 ; color forest green $1.7 ; molmap :2734-2939&:.B&$1 $2 gridspacing 2 modelid $1.8 ; setattr M name RY34 $1.8 ; color salmon $1.8 ; molmap :3614-4253&:.B&$1 $2 gridspacing 2 modelid $1.9 ; setattr M name CSol $1.9 ; color medium purple $1.9 ; molmap :4063-4135&:.B&$1 $2 gridspacing 2 modelid $1.10 ; setattr M name EF12 $1.10 ; color magenta $1.10 ; molmap :4177-4253&:.B&$1 $2 gridspacing 2 modelid $1.11 ; setattr M name TaF $1.11 ; color medium purple $1.11 ; molmap :4541-4820&:.B&$1 $2 gridspacing 2 modelid $1.12 ; setattr M name pVSD $1.12 ; color firebrick $1.12 ; molmap :4662-4786&:.B&$1 $2 gridspacing 2 modelid $1.13 ; setattr M name S23_domain $1.13 ; color firebrick $1.13 ; molmap :4821-4956&:.B&$1 $2 gridspacing 2 modelid $1.14 ; setattr M name Pore_domain $1.14 ; color orange $1.14 ; molmap :4957-&:.B&$1 $2 gridspacing 2 modelid $1.15 ; setattr M name CTD $1.15 ; color red $1.15 ; molmap :.A&$1 $2 gridspacing 2 modelid $1.16 ; setattr M name Cs2 $1.16 ; color gold $1.16 ; molmap :.C&$1 $2 gridspacing 2 modelid $1.17 ; setattr M name TMx $1.17 ; color black $1.17; molmap :.F&$1 $2 gridspacing 2 modelid $1.18 ; setattr M name CaM $1.17 ; color plum $1.18

#selects by color. Specify two word colors as forest_green.
#Usage: selbycolor color
alias ^selbycolor sel :/ribbonColor="$1" | :/color="$1" | @/color="$1"

#Selects all residues between two selected residues.
alias ^selbetween ac ri

#Copies selection.
alias ^copysel save ~/tmp1.py ; del ~sel ; combine sel modelid 1000; write relative #1000 #1000 ~/sel.pdb  ; close all ; open ~/tmp1.py ; open ~/sel.pdb

alias ^copysel_with_ref save ~/tmp1.py ; del ~sel ; combine sel modelid 1000 refspec $1; write relative $1 #1000 ~/sel.pdb  ; close all ; open ~/tmp1.py ; open ~/sel.pdb

alias ^copysel_single_model write selected $1 ~/tmp.pdb ; open ~/tmp.pdb

#Sets all maps to grid step 1
alias ^volstep1 volume # step 1

#Set maps to various thresholds
alias ^ryr_level1 volume # fastenclosevolume 2000000
alias ^ryr_level2 volume # fastenclosevolume 1000000
alias ^ryr_level3 volume # fastenclosevolume 500000

#Measure rotation between two domains.
#Usage: domain_rotation sel_for_domain1 sel_for_domain_2
alias ^domain_rotation savepos tmp; match $1 $2; measure rotation $1 $2; reset tmp

#Delete hydrogens
alias ^delh sel @H=@/element=H; del sel
alias ^delh_sel sel sel&@H=@/element=H; del sel

#Color by phi and psi angles.
alias ^color_by_phi_psi sel :/psi>=-90&:/psi<=30&:/phi>=-135&:/phi<=0; color blue sel; sel :/psi>=90&:/psi<=180&:/phi>=-180&:/phi<=0; color red sel

#Calculates a local difference map by extracting density around a selection (5A buffer) aligned to the two maps, aligning the extracted densities and subtracting one from the other.
#Usage: local_diff_map sel #map_id1 #map_id2
alias ^local_diff_map savepos tmp; close #1001,1002,1003,1004; fitmap $1 $2; vop zone $2 $1 5 modelid 1000 minimalbounds true; fitmap $1 $3; vop zone $3 $1 5 modelid 1001 minimalbounds true; fitmap #1001 #1000; vop resample #1001 ongrid #1000 modelid 1002; vop subtract #1000 #1002 modelid 1003 minrms true; volume #1003 step 1 ; split_diff_map #1003 #1004 ; close #1000,1001,1002,1003 ; reset tmp

#As above, with a 10A buffer.
alias ^local_diff_map_10 fitmap $1 $2; vop zone $2 $1 10 modelid 1000 minimalbounds true; fitmap $1 $3; vop zone $3 $1 10 modelid 1001 minimalbounds true; fitmap #1001 #1000; vop resample #1001 ongrid #1000 modelid 1002; vop subtract #1000 #1002 modelid 1003 minrms true; volume #1003 step 1 ; split_diff_map #1003 #1004 ; close #1000 #1001 #1002 ; fitmap $1 $2


#Set or unset crosshairs at center of rotation
alias ^cofron set showcofr; cofr view; clip on
alias ^cofroff ~set showcofr

#Make volume blue mesh
#Usage cootmode map_id
alias ^cootmode volume $1 capfaces false style mesh meshlighting false squaremesh false color "#4bd97685f684" step 1; sop cap off; set depthCue; set dcStart 0.2; set dcEnd 1; background solid black; cofron

#Usage cootmode_wire
alias ^cootmode_wire ~rib; disp; color gold; color byhet; repr wire; setattr m lineWidth 2; volume # capfaces false style mesh meshlighting false squaremesh false color "#3333851effff" step 1; sop cap off; set depthCue; set dcStart 0.5; set dcEnd 0.7; background solid black; cofron; symclip 5

#Usage cootmode_wire_white
alias ^cootmode_wire_white ~rib; disp; color gold; color byhet; repr wire; setattr m lineWidth 2; volume # capfaces false style mesh meshlighting false squaremesh false color "#00000000cccc" step 1; sop cap off; set depthCue; set dcStart 0.2; set dcEnd 1; background solid white; cofron; symclip 5

alias ^cootmode_off volume $1 style surface capfaces true color "cornflower blue"; sop cap on; background solid white

alias ^cootmode_white volume $1 capfaces false style mesh meshlighting false squaremesh false color "navy blue" step 1; sop cap off; set depthCue; set dcStart 0.2; set dcEnd 1; background solid white; cofron

#Creates named selections corresponding to RyR domains.
#Usage: ryr_namesel #model_id
alias ^ryr_namesel sel $1&:.B&:1-628; namesel ntd; sel $1&:.B&:1-209; namesel ntda; sel $1&:.B&:210-394; namesel ntdb; sel $1&:.B&:395-628; namesel nsol; namesel ntdc; sel $1&:629-1656&:.B&~:850-1055; namesel spry123 ; namesel spry; sel $1&:.B&:634-849; namesel spry1; sel $1&:.B&:1070-1240; namesel spry2; sel $1&:.B&:1244-1656; namesel spry3; sel $1&:.B&:1244-1656; sel $1&:.B&:850-1055; namesel ry12; sel $1&:.B&:2734-2939; namesel ry34; sel $1&:.B&:1657-2144; namesel jsol; sel $1&:.B&:2145-3613&~:2734-2939; namesel bsol; sel $1&:.B&:3639-4253; namesel csol; sel $1&:.B&:3614-3638; namesel bclinker; namesel bc_linker; namesel cslinker; namesel cs_linker; sel $1&:.B&:4063-4135; namesel ef12; namesel ef; namesel efh; sel $1&:.B&:4063-4101; namesel ef1; namesel efh1; sel $1&:.B&:4101-4135; namesel ef2; namesel efh2; sel :3639-&:.B&$1; namesel core; sel $1&:.B&:1-3613; namesel shell; sel $1&:.B&:4177-4253; namesel taf; sel $1&:.B&:4540-4937; namesel tm; sel $1&:.B&:4821-4937; namesel pore; sel $1&:.B&:4540-4820; namesel pvsd; sel $1&:.B&:4938-4956; namesel s6c; sel $1&:.B&:4957-; namesel ctd; sel $1&:.B&:4664-4786; namesel s23; sel $1&:.A; namesel fkbp; namesel cs2; sel $1&:.F; namesel cam; sel :unsel

#Colors ryr by domain.
#Usage: ryr_color #model_id
alias ^ryr_color color ntda ntda; color ntdb ntdb; color nsol nsol; color spry1 spry1; color spry2 spry2; color ry12 ry12; color spry3 spry3; color jsol jsol; color fkbp fkbp; color bsol bsol; color ry34 ry34; color csol csol; color ef12 ef12; color taf taf; color pvsd pvsd; color pore pore|s6c; color ctd ctd; sel helix|strand; ribrepr edged sel; ribinsidecolor gray; ~sel; ~disp

#Makes binary mask for map at entered contour
#Usage: binary_mask #map_id contour
alias ^binary_mask vop threshold $1 minimum $2 set 0 maximum $2 setmaximum 1 modelID 2000; volume #2000 level 0.5

# Makes binary mask at given threshold, then applies 10 pixel soft edge.
#Usage: soft_mask #map_id contour
alias ^soft_mask vop threshold $1 minimum $2 set 0 maximum $2 setmaximum 1 modelID 2000; vop falloff #2000 modelID #2001; volume #2001 level 0.5; close #2000

# adjust clipping symmetrically around the center of rotation
#Usage: symclip
#alias symclip cofr view; clip on; clip hither $1 fromCenter true; clip yon -$1 fromCenter true
alias symclip cofr view; cofr fixed; clip hither $1 fromCenter true; clip yon -$1 fromCenter true; cofr view; clip on

#Show CA trace with sidechains 
#Usage: ca_and_sidechains model_id
alias ^ca_and_sidechains sel $1; namesel tmp; ~ribbon tmp; ~disp tmp; sel tmp&@CA&protein; repr stick sel; disp sel; sel tmp&~protein; repr stick sel; disp sel;  setattr m stickScale 1.0 tmp;  sel side chain/base.without CA/C1'&tmp; repr stick sel; disp sel; setattr b radius 0.1 sel; color byhet tmp; sel @CA|@CB; namesel tmp2; sel tmp&tmp2; repr stick sel; setattr b radius 0.1 sel; sel @CD,N&:pro&tmp; disp sel; repr stick sel; setattr b radius 0.1 sel; ~sel

#Show CA trace with sidechains
#Usage: ca_and_sidechainsi_wire model_id
alias ^ca_and_sidechains_wire sel $1; repr wire sel; namesel tmp; ~ribbon tmp; ~disp tmp; sel tmp&@CA&protein; repr wire sel; disp sel;  sel side chain/base.without CA/C1'&tmp; repr wire sel; disp sel; color byhet tmp; sel @CA|@CB; namesel tmp2; sel tmp&tmp2; repr wire sel; sel @CD,N&:pro&tmp; disp sel; repr wire sel; setattr m lineWidth 2; ~sel

#Selects sidechains in selection (not including CA)
#Usage: selside sel, selside :1-30, etc.
alias ^selside sel side chain/base.without CA/C1' & $1

alias ^dispside sel side chain/base.without CA/C1' & $1; disp sel

alias ^dispside_sphere ~sel; ac mc; ~disp sel; sel sel z<$1; sel side chain/base.with CA/C1' & sel; disp sel


#Show smooth trace with sidechains
alias ^ca_and_sidechains_smooth ~ribbon $1; ~disp $1; sel @CA&protein; repr stick sel; disp sel; setattr M stickScale 1.0 $1;  sel side chain/base.without CA/C1'; repr stick sel; disp sel; setattr b radius 0.1 sel; color byhet $1; sel @CA|@CB; repr stick sel; setattr b radius 0.1 sel; sel @CD|@N&:pro; disp sel; repr stick sel; setattr b radius 0.1 sel; ~sel; ribbon $1; ribscale licorice; ribspline spec $1 cardinal


#Center on selected atoms and update CofR
#Usage centersel
#alias ^centersel focus; cofr view; clip hither 200 fromCenter true; clip yon -200 fromCenter true; center sel; cofr view; clip hither 10 fromCenter true; clip yon -10 fromCenter true; cofr sel; clip hither 10 fromCenter true; clip yon -10 fromCenter true; cofr view; set showcofr
alias ^centersel cofr fixed; clip hither 300 fromCenter true; clip yon -300 fromCenter true; cofr view; clip on; center sel; cofr sel; cofr fixed; clip hither 10 fromCenter true; clip yon -10 fromCenter true; cofr view

#Center on selected atoms and update CofR; create marker atom and select it
#Usage centersel2
alias ^centersel2 center sel; cofr sel; cofr view; set showcofr; ac mc

# shows sphere of density of selected radius around center of rotation
# Usage: map_sphere radius
alias ^map_sphere sel :unsel; ac mc; sop zone # sel $1; del sel; symclip $1
alias ^map_sphere_off ~sop zone #

#carve all maps to x A of sel
alias ^carve sop zone # sel $1
alias ^uncarve ~sop zone #

# Sets map to x*RMS
# Usage: sig #map_id rms
alias ^map_sig volume $1 sdlevel $2

alias ^diffmap_sig volume $1 rmsLevel -$2 color #da1200000000 rmsLevel $2 color #0000bda00000

#Set diffmap to absolute +/- levels - useful if map has been sigma scaled and then cropped.
alias ^diffmap_abs volume $1 level -$2 color #da1200000000 level $2 color #0000bda00000

#Load pdb and associated maps from EDS
# Usage: load_pdb_and_maps pdb_id
alias ^load_pdb_and_maps open 1000 $1; open 1001 edsID:$1; open 1002 edsdiffID:$1; cootmode_wire; map_sig #1001 1; diffmap_sig #1002 3

#Extend map by one unit cell in each direction
#Usage: extend_map #map_id
alias ^extend_map vop cover $1 fbox -1,-1,-1,2,2,2

#Make pipe for helix
#Usage: pipe sel (or atom-spec)
alias ^pipe sel sel&@CA; define axis helicalcorrection true radius 3.0 $1

#Place label here (at center of rotation).
#Usage: label_here "label_text" (replace spaces with _; they will be spaces in label)
alias label_here sel :unsel; ac mc; color black sel; repr bs sel; vdwdefine 0.01 sel; setattr a label $1 sel; transparency 100,a sel; sel :unsel

#label selected atoms without recentering
#Usage: label_sel "label_text"
alias label_sel savepos tmp; center sel; cofr sel; ~sel; ac mc; color black sel; repr bs sel; vdwdefine 0.01 sel; setattr a label $1 sel; transparency 100,a sel; ~sel; reset tmp

#label with x/y offset
#Usage:label_x_offset "label_text" xA
alias ^label_x_offset savepos label_x_offset_tmp; cofr view; clip on; center sel; cofr sel; ~sel; ac mc; namesel label_x_offset_tmp1; move x $2; cofr view; ac mc; namesel label_x_offset_tmp2; sel label_x_offset_tmp1 | label_x_offset_tmp2; color invisible sel; dist sel; setattr p label "" sel; setattr p drawMode 1 sel; sel label_x_offset_tmp2; label_sel $1;  sel label_x_offset_tmp1 | label_x_offset_tmp2; setattr p radius 0.1; reset label_x_offset_tmp; setattr p label ""

alias ^label_y_offset savepos label_y_offset_tmp; cofr view; clip on; center sel; cofr sel; ~sel; ac mc; namesel label_y_offset_tmp1; move y $2; cofr view; ac mc; namesel label_y_offset_tmp2; sel label_y_offset_tmp1 | label_y_offset_tmp2; color invisible sel; dist sel; setattr p label "" sel; setattr p drawMode 1 sel; sel label_y_offset_tmp2; label_sel $1; sel label_y_offset_tmp1 | label_y_offset_tmp2; setattr p radius 0.1; reset label_y_offset_tmp; setattr p label ""

#hide selected axes
#Usage: hide_axis
alias ^hide_axis ~sel; ~modeldisp sel

#show selected axes
#Usage: show_axis
alias ^show_axis ~sel; modeldisp sel

#set window size to 720p
#Usage: window_720p
alias ^window_720p windowsize 1280 720

#set window size to 1080p
#Usage: window_1080p
alias ^window_1080p windowsize 1920 1080

#set window size to 480p
#Usage: window_480p
alias ^window_480p windowsize 640 480

#Make labeled axes for helices in RyR1.
#Usage: ryr_pore_measure #model
alias ^ryr_pore_measure sel $1&:.B&:4914-4934&@CA; define axis radius 1 name s6 sel; label_sel "S6"; sel $1&:.B&:4935-4955&@CA; define axis radius 1 name s6c sel; label_sel "S6c"; sel $1&:.B&:4821-4831&@CA; define axis radius 1 name jm3 sel; label_sel "JM3"; sel $1&:.B&:4773-4785&@CA; define axis radius 1 name jm2 sel; label_sel "JM2"; sel $1&:.B&:4807-4818&@CA; define axis radius 1 name s4 sel; label_sel "S4"; sel $1&:.B&:4543-4557&@CA; define axis radius 1 name jm1 sel; label_sel "JM1"; sel $1&:.B&:4644-4662&@CA; define axis radius 1 name s2 sel; label_sel "S2"; sel $1&:.B&:4666-4681&@CA; define axis radius 1 name s2c sel; label_sel "S2c"; sel $1&:.B&:4560-4576&@CA; define axis radius 1 name s1 sel; label_sel "S1"; sel $1&:.B&:4787-4804&@CA; define axis radius 1 name s3 sel; label_sel "S3"; sel $1&:.B&:4835-4855&@CA; define axis radius 1 name s5 sel; label_sel "S5"; sel $1&:.B&:4881-4891&@CA; define axis radius 1 name pore_helix sel; label_sel "PH"; sel $1&:.B&:4208-4224&@CA; define axis radius 1 name TaF1 sel; label_sel "TaFα1"; sel $1&:.B&:4229-4251&@CA; define axis radius 1 name TaF2 sel; label_sel "TaFα2"; sel :4824&@CA&$1; define plane name membrane sel; sel :unsel


#Save session with maps. saves in home dir with directory name same as session.
# Usage: save_session_dir session-name
# Don't use spaces or under_scores in session names (or escape underscors like: \_).
alias ^save_session_dir  cd ~/Dropbox; system mkdir chimera_tmp; cd chimera_tmp; system mkdir packaged_sessions; cd packaged_sessions; system mkdir $1; volume # save ~/Dropbox/chimera_tmp/packaged_sessions/$1/$1%d.mrc; save ~/Dropbox/chimera_tmp/packaged_sessions/$1/$1; cd ~/Dropbox/chimera_tmp/packaged_sessions; system tar -zcvf $1.tar.gz $1

#Makes thin yellow cylinder from CA of selection (intended for marking contacts)
alias ^thin_axis define axis raiseTool false radius 0.1 color yellow sel&@CA

#Makes a pseudoprojection style view of the given volume
#Usage: volume_project #map_id
alias ^volume_project background solid black; volume $1 step 1 sdlevel 0,0 color white sdlevel 20,1 color white style solid projectionMode 3d maximumIntensityProjection true btCorrection true linearInterpolation true; unset depthCue

alias ^volume_project_rainbow background solid black; volume $1 level 0,0.225 color red level 0.05,0.625 color orange level 0.1,0.825 color yellow level 0.15,0.925 color green level 0.2,0.975 color cyan level 0.25,1 color blue style solid btCorrection true linearInterpolation true; unset depthCue



#Colors residues by modified Zappo coloring scheme (salmon, ILVAM; orange, FWY; blue, KRH; red, DE; green, STNQ; magenta, G; cyan, P; yellow, C; gray, unknown.)
#Usage: zappo
alias ^zappo sel :ile,leu,val,ala,met; color salmon sel; sel :phe,trp,tyr; color orange sel; sel :lys,arg,his; color #635EFF sel; sel :ser,thr,asn,gln; color  #00FF00 sel; sel :pro; color cyan sel; sel :gly; color magenta sel; sel :cys; color #FFFF00 sel; sel :asp,glu; color #FF0000 sel; sel :unk; color dim gray sel


alias zapposel namesel tmp; sel :ile,leu,val,ala,met & tmp; color salmon sel; sel :phe,trp,tyr &tmp; color orange sel; sel :lys,arg,his &tmp; color #635EFF sel; sel :ser,thr,asn,gln &tmp; color  #00FF00 sel; sel :pro &tmp; color cyan sel; sel :gly &tmp; color magenta sel; sel :cys &tmp; color #FFFF00 sel; sel :asp,glu&tmp; color #FF0000 sel; sel :unk &tmp; color dim gray sel

#Makes cubic map of specified edge length and voxel size, centered on specified map, then resamples input map on this dummy map.
#Usage: resample_dummy_map #map_id angpix edge_length
alias ^resample_dummy_map center $1; cofr $1; ac mc; molmap sel 10 gridSpacing $2 edgepadding $3 modelID 1000; vop resample $1 ongrid #1000

#Generates 50 A axis normal to and at center of screen.
alias ^screen_axis cofr view; savepos tmp; ac mc; namesel z1; clip hither -50;clip yon -50;cofr view; ac mc; namesel z2; reset tmp; clip hither 50;clip yon 50; cofr view; ac mc; namesel z3; sel z1 | z2 | z3; define axis radius 0.5 sel; ~disp sel; reset tmp

#add black residue labels to selection.
#Usage: rlabel_black
alias ^rlabel_black rlabel sel; color black,l sel

# move both clip planes hither or yon.
# Usage: zslab x 
# Move hither and yon clip planes towards (positive) or away (negative)
alias ^zslab clip hither $1; clip yon $1

#pbond. Places black stick pseudobond between two selected atoms.
#Usage: pbond
alias ^pbond dist sel; setattr p label "" sel; setattr p drawMode 1 sel; setattr p radius 0.03 sel

#pbond_label
#Usage: pbond_label
alias ^pbond_label dist sel; setattr p drawMode 1 sel; setattr p radius 0.03 sel

#pbond_here. Use with single atom selected
#Usage: pbond_here
alias ^pbond_here ac mc; dist sel; setattr p label "" sel; setattr p drawMode 1 sel; setattr p radius 0.03 sel; sel sel&~protein; color black sel; repr bs sel; vdwdefine 0.01 sel; transparency 100,a sel
