#!/bin/bash
# Name - ATP_find.sh
# Author - Vivek Gite under GPL v2.x+ and Haolin Luo
# Usage - Read filenames from a text file and take action on $file
# ----------------------------------------------------------------
set -e
in="${1:-input.txt}"
mkdir ~/ATP_find
[ ! -f "$in" ] && { echo "$0 - File $in not found."; exit 1; }

while IFS= read -r file
do
			atp=${file: -8}
			echo $atp
			find . -name "*$atp" -exec cp {} ~/c3 \;
done < "${in}"
