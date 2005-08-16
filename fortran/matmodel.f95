!------------------------------------------------------------------------------!
! SETUP

subroutine matmodel
use globals
integer :: iz, i1(3), i2(3), j1, j2, k1, k2, l1, l2

if ( ipe == 0 ) print '(a)', 'Material Model'
matmax = material(1,1:3)
matmin = material(1,1:3)
do iz = 1, nmat
  call zoneselect( mati(iz,:), npg, offset, hypocenter, i1, i2 )
  i1 = max( i1, i1core + halo1 )
  i2 = min( i2, i2core - halo2 )
  rho0 = material(iz,1)
  vp   = material(iz,2)
  vs   = material(iz,3)
  matmax = max( matmax, material(iz,1:3) )
  matmin = min( matmin, material(iz,1:3) )
  miu0 = rho0 * vs * vs
  lam0 = rho0 * ( vp * vp - 2 * vs * vs )
  yc0  = miu0 * ( lam0 + miu0 ) / 6 / ( lam0 + 2 * miu0 ) * 4 / dx ^ 2
  !nu  = .5 * lam0 / ( lam0 + miu0 )
  j1 = i1(1); j2 = i2(1) - 1
  k1 = i1(2); k2 = i2(2) - 1
  l1 = i1(3); l2 = i2(3) - 1
  s1(j1:j2,k1:k2,l1:l2) = rho0
  lam(j1:j2,k1:k2,l1:l2) = lam0
  miu(j1:j2,k1:k2,l1:l2) = miu0
  yc(j1:j2,k1:k2,l1:l2) = yc0
end do
courant = dt * matmax(2) * sqrt( 3 ) / dx   ! TODO: check, make general
if ( ipe == 0 ) print *, 'courant: 1 > ', courant
gamma = dt * viscosity

do iz = 1, nop
  call zoneselect( operi(iz,:), npg, offset, hypocenter, i1, i2 )
  i1 = max( i1, i1core + halo1 )
  i2 = min( i2, i2core - halo2 )
  opi1(iz,:) = i1;
  opi2(iz,:) = i2;
  j1 = i1(1); j2 = i2(1) - 1
  k1 = i1(2); k2 = i2(2) - 1
  l1 = i1(3); l2 = i2(3) - 1
  dfnc( s2, oper(iz), x, x, dx, 1, 1, i1, i2 );
end do
i = hypocenter(nrmdim)
select case ( nrmdim )
case(1); s2(i,:,:) = 0; yc(i,:,:) = 0
case(2); s2(:,i,:) = 0; yc(:,i,:) = 0
case(3); s2(:,:,i) = 0; yc(:,:,i) = 0
end select

j1 = i1(1); j2 = i2(1) - 1
k1 = i1(2); k2 = i2(2) - 1
l1 = i1(3); l2 = i2(3) - 1
if ( bc(1) == 1 ) s1(j1,:,:) = s1(j1+1,:,:); s2(j1,:,:) = s2(j1+1,:,:); end if
if ( bc(4) == 1 ) s1(j2,:,:) = s1(j2-1,:,:); s2(j2,:,:) = s2(j2-1,:,:); end if
if ( bc(2) == 1 ) s1(:,k1,:) = s1(:,k1+1,:); s2(:,k1,:) = s2(:,k1+1,:); end if
if ( bc(5) == 1 ) s1(:,k2,:) = s1(:,k2-1,:); s2(:,k2,:) = s2(:,k2-1,:); end if
if ( bc(3) == 1 ) s1(:,:,l1) = s1(:,:,l1+1); s2(:,:,l1) = s2(:,:,l1+1); end if
if ( bc(6) == 1 ) s1(:,:,l2) = s1(:,:,l2-1); s2(:,:,l2) = s2(:,:,l2-1); end if

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

i1 = halo + [ 1 1 1 ];
i2 = halo + np;
l = i1(3):i2(3);
k = i1(2):i2(2);
j = i1(1):i2(1);

yn(j,k,l) = 0.125 * ...
  ( s1(j,k,l) + s1(j-1,k-1,l-1) ...
  + s1(j-1,k,l) + s1(j,k-1,l-1) ...
  + s1(j,k-1,l) + s1(j-1,k,l-1) ...
  + s1(j,k,l-1) + s1(j-1,k-1,l) );
s1 = s1 .* s2;
rho(j,k,l) = 0.125 * ...
  ( s1(j,k,l) + s1(j-1,k-1,l-1) ...
  + s1(j-1,k,l) + s1(j,k-1,l-1) ...
  + s1(j,k-1,l) + s1(j-1,k,l-1) ...
  + s1(j,k,l-1) + s1(j-1,k-1,l) );
i = yn  ~= 0; yn(i)  = dt ./ yn(i);
i = rho ~= 0; rho(i) = dt ./ rho(i);

i = s2 ~= 0; s2(i) = 1 ./ s2(i);
lam(:,:,:) = lam(:,:,:) .* s2(:,:,:);
miu(:,:,:) = miu(:,:,:) .* s2(:,:,:);

s1(:,:,:) = 0;
s2(:,:,:) = 0;

if length( locknodes )
  locknodes(downdim,1:3) = 0;
  if n(1) < 5, locknodes([1 4],1:3) = 0; end
  if n(2) < 5, locknodes([2 5],1:3) = 0; end
  if n(3) < 5, locknodes([3 6],1:3) = 0; end
end
for iz = 1:size( locknodes, 1 )
  zone = locknodes(iz,4:9);
  [ i1, i2 ] = zoneselect( zone, halo, np, hypocenter, nrmdim );
  locki(:,:,iz) = [ i1; i2 ];
end

% PML damping
c1 =  8/15;
c2 = -3/100;
c3 =  1/1500;
tune = 3.5;
hmean = 2 * matmin .* matmax ./ ( matmin + matmax );
damp = tune * hmean(3) / dx * ( c1 + ( c2 + c3 * npml ) * npml );
i = npml:-1:1;
dampn = damp * ( i ./ npml ) .^ 2;
dampc = .5 * ( dampn + [ dampn(2:end) 0 ] );
dn1 = - 2 * dampn   ./ ( 2 + dt * dampn );
dc1 = ( 2 - dt * dampc ) ./ ( 2 + dt * dampc );
dn2 = 2 ./ ( 2 + dt * dampn );
dc2 = 2 * dt ./ ( 2 + dt * dampc );
p1 = []; p2 = []; p3 = []; p4 = []; p5 = []; p6 = [];
g1 = []; g2 = []; g3 = []; g4 = []; g5 = []; g6 = [];
n = [ nm 3 ];
n(1) = npml;
if bc(1), p1 = repmat( zero, n ); g1 = repmat( zero, n ); end % ALLOC
if bc(4), p4 = repmat( zero, n ); g4 = repmat( zero, n ); end % ALLOC
n = [ nm 3 ];
n(2) = npml;
if bc(2), p2 = repmat( zero, n ); g2 = repmat( zero, n ); end % ALLOC
if bc(5), p5 = repmat( zero, n ); g5 = repmat( zero, n ); end % ALLOC
n = [ nm 3 ];
n(3) = npml;
if bc(3), p3 = repmat( zero, n ); g3 = repmat( zero, n ); end % ALLOC
if bc(6), p6 = repmat( zero, n ); g6 = repmat( zero, n ); end % ALLOC
clear n


end subroutine

