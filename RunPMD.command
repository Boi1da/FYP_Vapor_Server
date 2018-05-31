#!/bin/sh

#  RunPMD.command
#  pokemon
#
#  Created by Armani on 16/04/2018.
#

echo "*********************************"
echo "Script Called!"
echo "*********************************"

echo "*********************************"
echo "Starting ..."
echo "*********************************"
echo ""

#Go to PMD Location (/Users/Armani/Desktop/pmd-bin-6.1.0/bin)
cd "${4}"
./run.sh cpd --minimum-tokens ${1} --files "${2}" --language ${3}
