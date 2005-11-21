% Isosurface viz
function h = isosurfviz( x, f, ic, cellfocus, isoval, volviz )

if cellfocus
  n = size( x ) - 1;
  j = 1:n(1);
  k = 1:n(2);
  l = 1:n(3);
  x = 0.125 * ( ...
    x(j,k,l,:) + x(j+1,k+1,l+1,:) + ...
    x(j+1,k,l,:) + x(j,k+1,l+1,:) + ...
    x(j,k+1,l,:) + x(j+1,k,l+1,:) + ...
    x(j,k,l+1,:) + x(j+1,k+1,l,:) );
end

if ic
  isoval = isoval * [ -1 1 ];
else
  ic = 1;
end
h = [];

if volviz
  x = permute( x, [2 1 3 4] );
  f = permute( f, [2 1 3 4] );
  for i = 1:length( isoval );
    ival = abs( isoval(i) );
    tmp = isosurface( x(:,:,:,1), x(:,:,:,2), x(:,:,:,3), ...
      f(:,:,:,ic) * sign( isoval(i) ), ival );
    if ~isempty( tmp.vertices )
      h(end+1) = patch( tmp, ...
        'CData', isoval(i), ...
        'EdgeColor', 'none', ...
        'FaceColor', 'flat', ...
        'AmbientStrength',  .6, ...
        'DiffuseStrength',  .6, ...
        'SpecularStrength', .9, ...
        'SpecularExponent', 10, ...
        'FaceLighting', 'phong', ...
        'BackFaceLighting', 'lit' );
    end
  end
else
  for i = 1:length( isoval );
isoval(i)
    h = [ h surfcontour( x, f(:,:,:,ic), isoval(i) ) ];
  end
end

