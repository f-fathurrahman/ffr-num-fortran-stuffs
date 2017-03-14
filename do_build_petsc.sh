#!/bin/bash

INC="-I/home/efefer/mysoftwares/petsc-3.7.5/include/"
LIB="-L/home/efefer/mysoftwares/petsc-3.7.5/lib -lpetsc"

bas=`basename $1 .F`

#mpifort -ffree-form $INC $1 $LIB -o $bas.x
mpifort -free $INC $1 $LIB -o $bas.x
