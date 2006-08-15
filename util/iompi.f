! MPI I/O for SCEC VM

      subroutine readpts( kerr )
      include 'in.h'
      include 'mpif.h'
      integer(kind=mpi_offset_kind) mpioffset
      call mpi_init( ierr )
      open( 1, file='nn', status='old' )
      read( 1, * ) nn
      close( 1 )
      call mpi_comm_rank( mpi_comm_world, impirank, ierr )
      call mpi_comm_size( mpi_comm_world, impisize, ierr )
      call mpi_file_set_errhandler( mpi_file_null,
     $  MPI_ERRORS_ARE_FATAL, ierr )
      nnl = nn / impisize
      if( nnl > ibig ) stop 'ibig too small'
      if( modulo(nnl,impisize) /= 0 ) nnl = nnl+1
      nn = min( nnl, nn-impirank*nnl )
      irealsize = 4
      mpioffset = impirank * nnl * irealsize
      call mpi_file_open( mpi_comm_world, 'rlon', mpi_mode_rdonly,
     $  mpi_info_null, ifh, ierr )
      call mpi_file_read_at( ifh, mpioffset, rlon, nn, mpi_real,
     $  mpi_status_ignore, ierr )
      call mpi_file_close( ifh, ierr )
      call mpi_file_open( mpi_comm_world, 'rlat', mpi_mode_rdonly,
     $  mpi_info_null, ifh, ierr )
      call mpi_file_read_at( ifh, mpioffset, rlat, nn, mpi_real,
     $  mpi_status_ignore, ierr )
      call mpi_file_close( ifh, ierr )
      call mpi_file_open( mpi_comm_world, 'rdep', mpi_mode_rdonly,
     $  mpi_info_null, ifh, ierr )
      call mpi_file_read_at( ifh, mpioffset, rdep, nn, mpi_real,
     $  mpi_status_ignore, ierr )
      call mpi_file_close( ifh, ierr )
      do i = 1, nn
        if(rdep(i).lt.0) 
     $    print *, 'Error: degative depth', i, rlon(i), rlat(i), rdep(i)
        if(rlon(i)/=rlon(i).or.rlat(i)/=rlat(i).or.rdep(i)/=rdep(i))
     $    print *, 'Error: NaN', i, rlon(i), rlat(i), rdep(i)
        rdep(i) = rdep(i) * 3.2808399
        if( rdep(i) .lt. rdepmin ) rdep(i) = rdepmin
      end do
      kerr = 0
      end

      subroutine writepts( kerr )
      include 'in.h'
      include 'mpif.h'
      integer(kind=mpi_offset_kind) mpioffset
      open( 1, file='nn', status='old' )
      read( 1, * ) nn
      close( 1 )
      call mpi_comm_rank( mpi_comm_world, impirank, ierr )
      call mpi_comm_size( mpi_comm_world, impisize, ierr )
      call mpi_file_set_errhandler( mpi_file_null,
     $  MPI_ERRORS_ARE_FATAL, ierr )
      nnl = nn / impisize
      if( modulo(nnl,impisize) /= 0 ) nnl = nnl+1
      nn = min( nnl, nn-impirank*nnl )
      irealsize = 4
      mpioffset = impirank * nnl * irealsize
      call mpi_file_open( mpi_comm_world, 'vp',
     $  mpi_mode_create + mpi_mode_wronly, mpi_info_null, ifh, ierr )
      call mpi_file_write_at( ifh, mpioffset, alpha, nn, mpi_real,
     $  mpi_status_ignore, ierr )
      call mpi_file_close( ifh, ierr )
      call mpi_file_open( mpi_comm_world, 'vs',
     $  mpi_mode_create + mpi_mode_wronly, mpi_info_null, ifh, ierr )
      call mpi_file_write_at( ifh, mpioffset, beta, nn, mpi_real,
     $  mpi_status_ignore, ierr )
      call mpi_file_close( ifh, ierr )
      call mpi_file_open( mpi_comm_world, 'rho',
     $  mpi_mode_create + mpi_mode_wronly, mpi_info_null, ifh, ierr )
      call mpi_file_write_at( ifh, mpioffset, rho, nn, mpi_real,
     $  mpi_status_ignore, ierr )
      call mpi_file_close( ifh, ierr )
      call mpi_finalize( ierr )
      kerr = 0
      do i = 1, nn
        if(alpha(i)/=alpha(i).or.beta(i)/=beta(i).or.rho(i)/=rho(i))
     $    print *, 'Error: NaN', i, rlon(i), rlat(i), rdep(i)
      end do
      end
