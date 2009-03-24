! Setup model dimensions
module m_setup
implicit none
contains

subroutine setup
use m_globals
use m_collective
use m_util
integer :: nl(3)

nt = max( nt, 0 )
ifn = abs( faultnormal )

! Partition for parallelization
if ( np0 == 1 ) np3 = 1
nl = ( nn - 1 ) / np3 + 1
nhalo = 1
if ( ifn /= 0 ) nhalo(ifn) = 2
nl = max( nl, nhalo )
np3 = ( nn - 1 ) / nl + 1
call rank( ip3, ipid, np3 )
nnoff = nl * ip3 - nhalo

! Master process
ip3root = xihypo / nl
master = .false.
if ( all( ip3 == ip3root ) ) master = .true.
call setroot( ip3root )

! Size of arrays
nl = min( nl, nn - nnoff - nhalo )
nm = nl + 2 * nhalo

! Boundary conditions
i1bc = 1  - nnoff
i2bc = nn - nnoff

! Non-overlapping core region
i1core = 1  + nhalo
i2core = nm - nhalo

! Node region
i1node = max( i1bc, 2 )
i2node = min( i2bc, nm - 1 )

! Cell region
i1cell = max( i1bc, 1 )
i2cell = min( i2bc - 1, nm - 1 )

! PML region
i1pml = i1pml - nnoff
i2pml = i2pml - nnoff

! Map rupture index to local indices, and test if fault on this process
if ( ifn /= 0 ) then
  irup = irup - nnoff(ifn)
  if ( irup + 1 < i1core(ifn) .or. irup > i2core(ifn) ) ifn = 0
end if

! Debugging
verb = master .and. debug > 0
sync = debug > 1
if ( debug > 2 ) then
  write( str, "( a,i6.6,a )" ) 'debug/db', ipid, '.py'
  open( 1, file=str, status='replace' )
  write( 1, "( 'ifn     = ', i8                                            )" ) ifn
  write( 1, "( 'irup    = ', i8                                            )" ) irup
  write( 1, "( 'ip      = ', i8                                            )" ) ip
  write( 1, "( 'ipid    = ', i8                                            )" ) ipid
  write( 1, "( 'np3     = ', i8, 2(',', i8)                                )" ) np3
  write( 1, "( 'ip3     = ', i8, 2(',', i8)                                )" ) ip3
  write( 1, "( 'nn      = ', i8, 2(',', i8)                                )" ) nn
  write( 1, "( 'nm      = ', i8, 2(',', i8)                                )" ) nm
  write( 1, "( 'bc1     = ', i8, 2(',', i8)                                )" ) bc1
  write( 1, "( 'bc2     = ', i8, 2(',', i8)                                )" ) bc2
  write( 1, "( 'nhalo   = ', i8, 2(',', i8)                                )" ) nhalo
  write( 1, "( 'nnoff   = ', i8, 2(',', i8)                                )" ) nnoff
  write( 1, "( 'i1bc    = ', i8, 2(',', i8), '; i2bc   = ', i8, 2(',', i8) )" ) i1bc, i2bc
  write( 1, "( 'i1pml   = ', i8, 2(',', i8), '; i2pml  = ', i8, 2(',', i8) )" ) i1pml, i2pml
  write( 1, "( 'i1core  = ', i8, 2(',', i8), '; i2core = ', i8, 2(',', i8) )" ) i1core, i2core
  write( 1, "( 'i1node  = ', i8, 2(',', i8), '; i2node = ', i8, 2(',', i8) )" ) i1node, i2node
  write( 1, "( 'i1cell  = ', i8, 2(',', i8), '; i2cell = ', i8, 2(',', i8) )" ) i1cell, i2cell
  close( 1 )
end if

end subroutine

end module

