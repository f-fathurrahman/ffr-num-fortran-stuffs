PROGRAM matrices
  
  IMPLICIT NONE 
#include <petsc/finclude/petsc.h>

  Mat :: A, B
  PetscInt :: N
  PetscInt :: Istart, Iend, i, j
  PetscBool :: flg
  PetscScalar :: v
  PetscErrorCode :: ierr
  PetscMPIInt :: rank

  CALL PetscInitialize( PETSC_NULL_CHARACTER, ierr )

  CALL MPI_Comm_rank( PETSC_COMM_WORLD, rank, ierr )

  IF ( rank == 0 ) THEN 
    WRITE(*,*) 'Hello there ...'
  ENDIF 

  N = 30 ! default value for N
  CALL PetscOptionsGetInt( PETSC_NULL_OBJECT, PETSC_NULL_CHARACTER, &
                           '-N', N, flg, ierr )
  IF( rank == 0 ) THEN 
    WRITE(*,*) 'N = ', N
    WRITE(*,*) 'flg = ', flg
    WRITE(*,*) 'ierr = ', ierr
  ENDIF 

  CALL MatCreate( PETSC_COMM_WORLD, A, ierr )
  CALL MatSetSizes( A, PETSC_DECIDE, PETSC_DECIDE, N, N, ierr )
  CALL MatSetFromOptions( A, ierr )
  CALL MatSetUp( A, ierr )

  !CALL MatGetOwnershipRange( A, Istart, Iend, ierr )
  DO i = 1, N
    DO j = 1, N
      v = 10.0*i + j
      CALL MatSetValues( A, 1, i, 1, j, v, INSERT_VALUES, ierr )
    ENDDO 
  ENDDO 

  CALL MatAssemblyBegin( A, MAT_FINAL_ASSEMBLY )
  CALL MatAssemblyEnd( A, MAT_FINAL_ASSEMBLY )

  CALL PetscFinalize( ierr )

END PROGRAM 
