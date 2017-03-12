PROGRAM test_petsc_use_complex
  IMPLICIT NONE 

#include <petsc/finclude/petscsys.h>

#if defined(PETSC_USE_COMPLEX)
  WRITE(*,*) 'PETSC_USE_COMPLEX is defined'
#else
  WRITE(*,*) 'PETSC_USE_COMPLEX is not defined'
#endif

END PROGRAM 

