set filelist [glob *.pdb]
foreach file $filelist {
  mol new $file waitfor all
  set ATP [atomselect top "resname ATP"]
  $ATP writepdb ATP_$file
  mol delete top


}
close $file