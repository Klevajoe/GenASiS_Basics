!module mod_kinds

!  use iso_fortran_env, only: int32, int64, real32, real64, real128

!  implicit none

!  private
!  public :: ik, rk, fk

!#ifdef REAL64
!  integer,parameter :: rk = real64
!#elif REAL128
!  integer,parameter :: rk = real128
!#elif REAL32
!  integer,parameter :: rk = real32
!#else
!  integer,parameter :: rk = real32
!#endif

!integer,parameter :: fk = selected_real_kind(12)

!#ifdef INT64
!  integer, parameter :: ik = int64
!#elif INT32
!  integer, parameter :: ik = int32
!#else
!  integer, parameter :: ik = int32
!#endif

!end module mod_kinds

module mod_kinds

  use iso_fortran_env, only: int32, int64, real32, real64, real128

  implicit none

  ! Define the public variables
  integer, public, parameter :: ik = SELECTED_INT_KIND(9)  ! Default to 32-bit integer
  integer, public, parameter :: rk = SELECTED_REAL_KIND(6, 30)  ! Default to real64
  integer, public, parameter :: fk = SELECTED_REAL_KIND(12)     ! Default to real64

  ! Conditionally redefine variables based on preprocessor macros
#ifdef REAL32
  integer, parameter :: rk = SELECTED_REAL_KIND(6, 15)
#elif REAL128
  integer, parameter :: rk = SELECTED_REAL_KIND(18, 4931)
#endif

#ifdef INT64
  integer, parameter :: ik = SELECTED_INT_KIND(18)
#endif

end module mod_kinds

