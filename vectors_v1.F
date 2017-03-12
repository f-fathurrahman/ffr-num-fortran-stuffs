
PROGRAM vectors

IMPLICIT NONE 

#include <petsc/finclude/petscsys.h>
#include <petsc/finclude/petscvec.h>

  Vec x, y, w
  Vec z(5)  ! array of vectors

  PetscReal norm, v, v1, v2
  PetscBool flg
  PetscErrorCode ierr
  PetscScalar one, two, three
  PetscInt n, ithree

  CALL PetscInitialize( PETSC_NULL_CHARACTER, ierr )

  one   = 1.0
  two   = 2.0
  three = 3.0

  n = 20
  ithree = 3

  CALL PetscOptionsGetInt( PETSC_NULL_OBJECT, PETSC_NULL_CHARACTER, &
                           '-n', n, flg, ierr )

  CALL PetscFinalize(ierr)

  WRITE(*,*) 'Pass here ...'

END PROGRAM

