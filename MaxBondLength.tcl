# Tcl code to measure the maximum bond length written by Mahdi Tavakol (mahditavakol90@gmail.com)
mol load pdb 
mol addfile "example.dcd" waitfor all molid top

set backbone  [atomselect top "protein and name CA"]
set numFrames [molinfo top get numframes]
set file      [open "MaxBondLength.dat"]
set bonds     [$backbone getbonds]
set atoms     [$backbone num]

for {set k 0} {$k < $numFrames} {incr k} {
	set bondLengths {}
	for {set i 0} {$i < $atoms} {incr i} {
		set atomIBonds [lindex $bonds $i]
		set Num        [llength $atomIBonds]
		set BBids      [$backbone get index]
		for {set j 0} {$j < $Num} {incr j} {
			set atomIIndex [lindex $BBids $i]
			set atomJIndex [lindex $atomIBonds $j]
			#set atomI [atomselect top "index $atomIIndex"]
			#set atomJ [atomselect top "index $atomJIndex"]
			set bondIJ [measure bond [list $atomIIndex $atomJIndex] frame $k]
			lappend bondLengths $bondIJ
		}
	}

	set numBonds [llength $bondLengths]
	set maxBondLength 0

	for {set i 0} {$i < $numBonds} {incr i} {
		set bondI [lindex $bondLengths $i]
		if {$bondI > $maxBondLength} {
			set maxBondLength  $bondI
		}
	}
	puts $file "$k $maxBondLength"
}


