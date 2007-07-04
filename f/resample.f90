! Initial state
module m_resample
implicit none
contains

subroutine resample
use m_globals
use m_collective
use m_diffnc
use m_bc
use m_util
integer :: i, i1(3), i2(3), bc(3)


integer :: j, k, l

if ( master ) write( 0, * ) 'Resample material model'

! Cell volume
call diffnc( s1, w1, 1, 1, i1cell, i2cell, oplevel, bb, xx, dx1, dx2, dx3, dx )

! Zero volume and hourglass viscosity outside boundary, and at fault cell
i1 = i1bc
i2 = i2bc - 1
call scalarsethalo( s1, 0., i1, i2 )
call scalarsethalo( yy, 0., i1, i2 )
select case( ifn )
case( 1 ); i = ihypo(1); s1(i,:,:) = 0.; yy(i,:,:) = 0.
case( 2 ); i = ihypo(2); s1(:,i,:) = 0.; yy(:,i,:) = 0.
case( 3 ); i = ihypo(3); s1(:,:,i) = 0.; yy(:,:,i) = 0.
end select

j = ihypo(1)
k = ihypo(2)
l = ihypo(3)

print *, ihypo + nnoff
print *, 'vs'; print *, s2(j-8,k-1,:)
print *, 'gam'; print *, gam(j-7,k-1,:)
print *, 'gam'; print *, gam(j-8,k-1,:)
print *, 'gam'; print *, gam(j-7,k,:)
print *, 'gam'; print *, gam(j-8,k,:)

! Mass ratio
s2 = mr * s1
call scalaraverage( mr, s2, i1node, i2node, -1 )
where ( mr /= 0. ) mr = 1. / mr
call scalarswaphalo( mr, nhalo )
call scalarbc( mr, bc1, bc2, i1bc, i2bc )

! Viscosity, bc=4 means copy into halo for resampling at the node
bc = 4
i1 = i1bc - 1
i2 = i2bc
call scalarbc( gam, bc, bc, i1, i2 )
print *, 'bc'; print *, gam(j-8,k-1,:)
s2 = gam * dt
print *, 'dt'; print *, s2(j-8,k-1,:) / dt
call scalaraverage( gam, s2, i1node, i2node, -1 )
print *, 'av'; print *, gam(j-8,k,:) / dt
call scalarsethalo( gam, 0., i1bc, i2bc )
call scalarswaphalo( gam, nhalo )
call scalarbc( gam, bc1, bc2, i1bc, i2bc )
print *, 'final'; print *, gam(j-8,k,:) / dt
!stop

! Moduli
where ( s1 /= 0. ) s1 = 1. / s1
lam = lam * s1
mu = mu * s1

! Initial state
  tm    =  0.
  vv    =  0.
  uu    =  0.
  w1    =  0.
! z1    =  0.
! z2    =  0.
  sl    =  0.
  p1    =  0.
  p2    =  0.
  p3    =  0.
  p4    =  0.
  p5    =  0.
  p6    =  0.
  g1    =  0.
  g2    =  0.
  g3    =  0.
  g4    =  0.
  g5    =  0.
  g6    =  0.
  pv    =  0.
  psv   =  0.
  trup  =  1e9
  tarr  =  0.
  efric =  0.

  w2    =  0.
  s1    =  0.
  s2    =  0.
  t1    =  0.
  t2    =  0.
  f1    =  0.
  f2    =  0.

end subroutine

end module

