proc dihedral {name1 name2 name3 name4 frag {molid top}} {
  set ixlist {}
  set sel1 [atomselect $molid "fragment $frag and name $name1"]
  lappend ixlist [$sel1 get index]
  set sel2 [atomselect $molid "fragment $frag and name $name2"]
  lappend ixlist [$sel2 get index]
  set sel3 [atomselect $molid "fragment $frag and name $name3"]
  lappend ixlist [$sel3 get index]
  set sel4 [atomselect $molid "fragment $frag and name $name4"]
  lappend ixlist [$sel4 get index]
  return [measure dihed $ixlist]
}

proc ang {name1 name2 name3 frag {molid top}} {
  set ixlist {}
  set sel1 [atomselect $molid "fragment $frag and name $name1"]
  lappend ixlist [$sel1 get index]
  set sel2 [atomselect $molid "fragment $frag and name $name2"]
  lappend ixlist [$sel2 get index]
  set sel3 [atomselect $molid "fragment $frag and name $name3"]
  lappend ixlist [$sel3 get index]
  return [measure angle $ixlist]
}

set file1 [open data_ATP_pose.txt w]

set filelist [glob *.pdb]
puts $filelist
foreach file $filelist {
  set molid [mol new $file waitfor all]
  mol top $molid
  set sel [atomselect top "resname ATP"]
  set fraglist [lsort -unique [$sel get fragment]]
  foreach fragID $fraglist {
set di1 [dihedral "C3'" "C4'" "C5'" "O5'" $fragID]
set di2 [dihedral "C4'" "C5'" "O5'" "PA" $fragID]
set di3 [dihedral "C5'" "O5'" "PA" "O3A" $fragID]
set ang1 [ang "N1" "C5'" "PG" $fragID]
  set sel [atomselect top "fragment $fragID and resname ATP and pbwithin 5 of protein" ]
    if {[llength [$sel get index]] !=0 } {
      set atp_position "P"
    } else {
      set atp_position "A"
    }
set protein [atomselect top "all"]
set atp_frag [atomselect top "fragment $fragID and resname ATP"]
set sasa [measure sasa 1.4 $protein -restrict $atp_frag]
puts $file1 "$file, $fragID, $di1, $di2, $di3, $ang1, $atp_position, $sasa"
  }
  mol delete top
}
close $file1