PROGRAM matrices
  
  IMPLICIT NONE 
#include <petsc/finclude/petsc.h>

  Mat :: A, B
  PetscInt :: N
  PetscInt :: irow, icol
  PetscBool :: flg
  PetscScalar :: v
  PetscErrorCode :: ierr
  PetscMPIInt :: rank

  CALL PetscInitialize( PETSC_NULL_CHARACTER, ierr )

  CALL MPI_Comm_rank( PETSC_COMM_WORLD, rank, ierr )

  IF ( rank == 0 ) THEN 
    WRITE(*,*) 'Hello there ...'
  ENDIF 

  N = 5 ! default value for N
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

  IF ( rank == 0 ) THEN 
    DO irow = 0, N-1
      DO icol = 0, N-1  ! start from zero !!
        v = 10.0*irow + icol
        CALL MatSetValues( A, 1, irow, 1, icol, v, INSERT_VALUES, ierr )
        !WRITE(*,*) 'row, col, ierr = ', irow, icol, ierr
      ENDDO 
    ENDDO
  ENDIF

  CALL MatAssemblyBegin( A, MAT_FINAL_ASSEMBLY, ierr )
  CALL MatAssemblyEnd( A, MAT_FINAL_ASSEMBLY, ierr )

  CALL MatView( A, PETSC_VIEWER_STDOUT_WORLD, ierr )

  CALL PetscFinalize( ierr )

END PROGRAM 
