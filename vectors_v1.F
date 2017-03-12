PROGRAM vectors

  IMPLICIT NONE 

#include <petsc/finclude/petscsys.h>
#include <petsc/finclude/petscvec.h>

  Vec x, y, w
  Vec z(5)  ! array of vectors

  PetscReal :: norm, v, v1, v2
  PetscBool :: flg
  PetscErrorCode :: ierr
  PetscScalar :: one, two, three
  PetscInt :: n, ithree
  PetscReal :: nfloat
  PetscMPIInt :: rank
  CHARACTER(40) :: name_
  PetscScalar :: dots(3), dot
  INTEGER :: i

  CALL PetscInitialize( PETSC_NULL_CHARACTER, ierr )

  one   = 1.0
  two   = 2.0
  three = 3.0

  n = 20
  ithree = 3

  CALL PetscOptionsGetInt( PETSC_NULL_OBJECT, PETSC_NULL_CHARACTER, &
                           '-n', n, flg, ierr )
  nfloat = n
  WRITE(*,*) 'n, float = ', n, nfloat

  CALL MPI_Comm_rank( PETSC_COMM_WORLD, rank, ierr )

  ! Create a vector
  CALL VecCreate( PETSC_COMM_WORLD, x, ierr )
  CALL VecSetSizes( x, PETSC_DECIDE, n, ierr )
  CALL VecSetFromOptions( x, ierr )
  CALL VecGetType( x, name_, ierr )
  WRITE(*,*) 'name_ = ', trim(name_)

  ! Duplicate some work vectors of the same format and partitioning as
  ! the initial vector
  CALL VecDuplicate( x, y, ierr )
  CALL VecDuplicate( x, w, ierr )

  ! Duplicate more work vectors of the same format and partitioning as
  ! the initial vector. Here we duplicate an array of vectors, which is often
  ! more convenient than duplicating individual ones.
  CALL VecDuplicateVecs( x, ithree, z, ierr )

  ! Set the vectors to entries to a constant value.
  CALL VecSet( x, one, ierr )
  CALL VecSet( y, two, ierr )
  CALL VecSet( z(1), one, ierr )
  CALL VecSet( z(2), two, ierr )
  CALL VecSet( z(3), three, ierr )

  ! Dot product
  CALL VecDot( x, x, dot, ierr )
  ! Multiple dot products
  CALL VecMDot( x, ithree, z, dots, ierr )

  IF ( rank == 0 ) THEN 
    WRITE(*,*) 'dot ', dot
    DO i = 1, 3
      WRITE(*,*) 'i, dots(i)', i, dots(i)
    ENDDO 
  ENDIF 

  IF ( rank == 0 ) THEN 
    WRITE(*,*) 'PETSC_SMALL = ', PETSC_SMALL
  ENDIF 

  ! Scaling operation
  CALL VecScale( x, two, ierr )
  CALL VecNorm( x, NORM_2, norm, ierr )
  v = abs( norm-2.0*sqrt(nfloat))
  IF( rank == 0 ) THEN 
    WRITE(*,*) 'norm (after VecScale) = ', norm
    WRITE(*,'(1x,A,1pe8.2)') 'VecScale: ', v
  ENDIF 
  
  ! calculate y = alpha*y + x
  CALL VecAYPX( y, two, x, ierr ) 
  CALL VecNorm( y, NORM_2, norm, ierr )
  v = abs( norm-18.0*sqrt(nfloat) )
  IF( rank == 0 ) THEN 
    WRITE(*,*) 'norm (after VecAYPX) = ', norm
    WRITE(*,'(1x,A,1pe8.2)') 'VecAYPX: ', v
  ENDIF 

  ! calculate w = alpha*x + y
  CALL VecWAXPY( w, two, x, y, ierr )
  CALL VecNorm( w, NORM_2, norm, ierr )
  IF( rank == 0 ) THEN 
    WRITE(*,*) 'norm(w) = ', norm
  ENDIF 

  ! Free memory
  CALL VecDestroy( x, ierr )
  CALL VecDestroy( y, ierr )
  CALL VecDestroy( w, ierr )
  CALL VecDestroyVecs( ithree, z, ierr )

  CALL PetscFinalize(ierr)

  WRITE(*,*) 'Pass here ...'

END PROGRAM

