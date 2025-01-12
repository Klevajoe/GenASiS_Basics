!-- MultiplyAdd provides an overloaded interface to multiply and add matrices,
!   in order to expose elemental variables to the compiler and include 
!   threading.

#include "Preprocessor"

module MultiplyAdd_Command

  use iso_c_binding
  use Specifiers
  
  public :: &
    MultiplyAdd, &
    MultiplyAddCollapse
    
  interface MultiplyAdd
    module procedure MultiplyAddReal_1D
    module procedure MultiplyAddReal_1D_InPlace
    module procedure MultiplyAddReal_2D
    module procedure MultiplyAddReal_2D_InPlace
    module procedure MultiplyAddReal_3D
    module procedure MultiplyAddReal_3D_InPlace
  end interface

  interface MultiplyAddCollapse
    module procedure MultiplyAddCollapse_3D_Offset
  end interface MultiplyAddCollapse

contains


  subroutine MultiplyAddReal_1D ( A, B, C, D, UseDeviceOption )
  
    real ( KDR ), dimension ( : ), intent ( in ) :: &
      A, &
      B
    real ( KDR ), intent ( in ) :: &
      C
    real ( KDR ), dimension ( : ), intent ( out ) :: &
      D
    logical ( KDL ), intent ( in ), optional :: &
      UseDeviceOption
                      
    integer ( KDI ) :: &
      iV, &
      nV
    logical ( KDL ) :: &
      UseDevice
      
    UseDevice = .false.
    if ( present ( UseDeviceOption ) ) &
      UseDevice = UseDeviceOption

    nV = size ( A )

    if ( UseDevice ) then
      !$OMP OMP_TARGET_DIRECTIVE parallel do &
      !$OMP schedule ( OMP_SCHEDULE_TARGET )
      do iV  =  1,  nV
        D ( iV )  =  A ( iV )  +  C * B ( iV )
      end do
      !$OMP end OMP_TARGET_DIRECTIVE parallel do
    else 
      !$OMP parallel do &
      !$OMP schedule ( OMP_SCHEDULE_HOST )
      do iV  =  1,  nV
        D ( iV )  =  A ( iV )  +  C * B ( iV )
      end do
      !$OMP end parallel do
    end if
    
  end subroutine MultiplyAddReal_1D


  subroutine MultiplyAddReal_1D_InPlace ( A, B, C, UseDeviceOption )
  
    real ( KDR ), dimension ( : ), intent ( inout ) :: &
      A
    real ( KDR ), dimension ( : ), intent ( in ) :: &
      B
    real ( KDR ), intent ( in ) :: &
      C
    logical ( KDL ), intent ( in ), optional :: &
      UseDeviceOption
                      
    integer ( KDI ) :: &
      iV, &
      nV
    logical ( KDL ) :: &
      UseDevice
      
    UseDevice = .false.
    if ( present ( UseDeviceOption ) ) &
      UseDevice = UseDeviceOption

    nV = size ( A )
    
    if ( UseDevice ) then
      !$OMP OMP_TARGET_DIRECTIVE parallel do &
      !$OMP schedule ( OMP_SCHEDULE_TARGET )
      do iV  =  1,  nV
        A ( iV )  =  A ( iV )  +  C * B ( iV )
      end do
      !$OMP end OMP_TARGET_DIRECTIVE parallel do
    else 
      !$OMP parallel do &
      !$OMP schedule ( OMP_SCHEDULE_HOST )
      do iV  =  1,  nV
        A ( iV )  =  A ( iV )  +  C * B ( iV )
      end do
      !$OMP end parallel do
    end if
    
  end subroutine MultiplyAddReal_1D_InPlace


  subroutine MultiplyAddReal_2D ( A, B, C, D, UseDeviceOption )
  
    real ( KDR ), dimension ( :, : ), intent ( inout ) :: &
      A
    real ( KDR ), dimension ( :, : ), intent ( in ) :: &
      B
    real ( KDR ), intent ( in ) :: &
      C
    real ( KDR ), dimension ( :, : ), intent ( out ) :: &
      D
    logical ( KDL ), intent ( in ), optional :: &
      UseDeviceOption
                      
    integer ( KDI ) :: &
      iV, jV
    integer ( KDI ), dimension ( 2 ) :: &
      nV
    logical ( KDL ) :: &
      UseDevice
      
    UseDevice = .false.
    if ( present ( UseDeviceOption ) ) &
      UseDevice = UseDeviceOption

    nV  =  shape ( A )

    if ( UseDevice ) then
      !$OMP OMP_TARGET_DIRECTIVE parallel do collapse ( 2 ) &
      !$OMP schedule ( OMP_SCHEDULE_TARGET )
      do jV  =  1,  nV ( 2 )
        do iV  =  1,  nV ( 1 )
          D ( iV, jV )  =  A ( iV, jV )  +  C * B ( iV, jV )
        end do
      end do
      !$OMP end OMP_TARGET_DIRECTIVE parallel do
    else 
      !$OMP parallel do collapse ( 2 ) &
      !$OMP schedule ( OMP_SCHEDULE_HOST )
      do jV  =  1,  nV ( 2 )
        do iV  =  1,  nV ( 1 )
          D ( iV, jV )  =  A ( iV, jV )  +  C * B ( iV, jV )
        end do
      end do
      !$OMP end parallel do
    end if
    
  end subroutine MultiplyAddReal_2D


  subroutine MultiplyAddReal_2D_InPlace ( A, B, C, UseDeviceOption )
  
    real ( KDR ), dimension ( :, : ), intent ( inout ) :: &
      A
    real ( KDR ), dimension ( :, : ), intent ( in ) :: &
      B
    real ( KDR ), intent ( in ) :: &
      C
    logical ( KDL ), intent ( in ), optional :: &
      UseDeviceOption
                      
    integer ( KDI ) :: &
      iV, jV
    integer ( KDI ), dimension ( 2 ) :: &
      nV
    logical ( KDL ) :: &
      UseDevice
      
    UseDevice = .false.
    if ( present ( UseDeviceOption ) ) &
      UseDevice = UseDeviceOption

    nV  =  shape ( A )

    if ( UseDevice ) then
      !$OMP OMP_TARGET_DIRECTIVE parallel do collapse ( 2 ) &
      !$OMP schedule ( OMP_SCHEDULE_TARGET )
      do jV  =  1,  nV ( 2 )
        do iV  =  1,  nV ( 1 )
          A ( iV, jV )  =  A ( iV, jV )  +  C * B ( iV, jV )
        end do
      end do
      !$OMP end OMP_TARGET_DIRECTIVE parallel do
    else 
      !$OMP parallel do collapse ( 2 ) &
      !$OMP schedule ( OMP_SCHEDULE_HOST )
      do jV  =  1,  nV ( 2 )
        do iV  =  1,  nV ( 1 )
          A ( iV, jV )  =  A ( iV, jV )  +  C * B ( iV, jV )
        end do
      end do
      !$OMP end parallel do
    end if
    
  end subroutine MultiplyAddReal_2D_InPlace


  subroutine MultiplyAddReal_3D ( A, B, C, D, UseDeviceOption )

    real ( KDR ), dimension ( :, :, : ), intent ( in ) :: &
      A, &
      B
    real ( KDR ), intent ( in ) :: &
      C
    real ( KDR ), dimension ( :, :, : ), intent ( out ) :: &
      D
    logical ( KDL ), intent ( in ), optional :: &
      UseDeviceOption
    
    integer ( KDI ) :: &
      iV, jV, kV
    integer ( KDI ), dimension ( 3 ) :: &
      nV
    logical ( KDL ) :: &
      UseDevice
      
    UseDevice = .false.
    if ( present ( UseDeviceOption ) ) &
      UseDevice = UseDeviceOption

    nV  =  shape ( A )

    if ( UseDevice ) then
      !$OMP OMP_TARGET_DIRECTIVE parallel do collapse ( 3 ) &
      !$OMP schedule ( OMP_SCHEDULE_TARGET )
      do kV  =  1,  nV ( 3 )
        do jV  =  1,  nV ( 2 )
          do iV  =  1,  nV ( 1 )
            D ( iV, jV, kV )  =  A ( iV, jV, kV )  +  C * B ( iV, jV, kV )
          end do !-- iV
        end do !-- jV
      end do !-- kV
      !$OMP end OMP_TARGET_DIRECTIVE parallel do
    else 
      !$OMP parallel do collapse ( 3 ) &
      !$OMP schedule ( OMP_SCHEDULE_HOST )
      do kV  =  1,  nV ( 3 )
        do jV  =  1,  nV ( 2 )
          do iV  =  1,  nV ( 1 )
            D ( iV, jV, kV )  =  A ( iV, jV, kV )  +  C * B ( iV, jV, kV )
          end do !-- iV
        end do !-- jV
      end do !-- kV
      !$OMP end parallel do
    end if
    
  end subroutine MultiplyAddReal_3D


  subroutine MultiplyAddReal_3D_InPlace ( A, B, C, UseDeviceOption )
  
    real ( KDR ), dimension ( :, :, : ), intent ( inout ) :: &
      A
    real ( KDR ), dimension ( :, :, : ), intent ( in ) :: &
      B
    real ( KDR ), intent ( in ) :: &
      C
    logical ( KDL ), intent ( in ), optional :: &
      UseDeviceOption
                      
    integer ( KDI ) :: &
      iV, jV, kV
    integer ( KDI ), dimension ( 3 ) :: &
      nV
    logical ( KDL ) :: &
      UseDevice
      
    UseDevice = .false.
    if ( present ( UseDeviceOption ) ) &
      UseDevice = UseDeviceOption

    nV  =  shape ( A )

    if ( UseDevice ) then
      !$OMP OMP_TARGET_DIRECTIVE parallel do collapse ( 3 ) &
      !$OMP schedule ( OMP_SCHEDULE_TARGET )
      do kV  =  1,  nV ( 3 )
        do jV  =  1,  nV ( 2 )
          do iV  =  1,  nV ( 1 )
            A ( iV, jV, kV )  =  A ( iV, jV, kV )  +  C * B ( iV, jV, kV )
          end do !-- iV
        end do !-- jV
      end do !-- kV
      !$OMP end OMP_TARGET_DIRECTIVE parallel do
    else 
      !$OMP parallel do collapse ( 3 ) &
      !$OMP schedule ( OMP_SCHEDULE_HOST )
      do kV  =  1,  nV ( 3 )
        do jV  =  1,  nV ( 2 )
          do iV  =  1,  nV ( 1 )
            A ( iV, jV, kV )  =  A ( iV, jV, kV )  +  C * B ( iV, jV, kV )
          end do !-- iV
        end do !-- jV
      end do !-- kV
      !$OMP end parallel do
    end if

  end subroutine MultiplyAddReal_3D_InPlace


  subroutine MultiplyAddCollapse_3D_Offset ( A, B, C, oV )

    real ( KDR ), dimension ( :, :, : ), intent ( inout ) :: &
      A
    real ( KDR ), dimension ( :, :, : ), intent ( in ) :: &
      B
    real ( KDR ), intent ( in ) :: &
      C
    integer ( KDI ), dimension ( 3 ), intent ( in ) :: &
      oV
    
    integer ( KDI ) :: &
      iV, jV, kV
    integer ( KDI ), dimension ( 3 ) :: &
      nV

    nV = shape ( A )

    !$OMP parallel do private ( iV, jV, kV ) collapse ( 3 )
    do kV = 1, nV ( 3 )
      do jV = 1, nV ( 2 )
        do iV = 1, nV ( 1 )
          A ( iV, jV, kV ) &
            = A ( iV, jV, kV )  &
              +  C * B ( oV ( 1 ) + iV, oV ( 2 ) + jV, oV ( 3 ) + kV )
        end do !-- iV
      end do !-- jV
    end do !-- kV
    !$OMP end parallel do

  end subroutine MultiplyAddCollapse_3D_Offset


end module MultiplyAdd_Command
