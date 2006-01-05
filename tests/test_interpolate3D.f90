!
!--unit test for interpolation routines
!
program test_interpolation
 use projections3D
 use xsections3D
 implicit none
 integer, parameter :: idimx = 100
 integer, parameter :: idim = idimx**3
 integer :: npart,npartx,nparty,npartz
 integer :: npixx, npixy
 real, dimension(idim) :: x,y,z,pmass,h,rho
 real, dimension(idim) :: dat,weight
 real, dimension(1000,1000) :: datpix
 real :: xmin,xmax,ymin,ymax,zmin,zmax
 real :: columndens,dxpix,err,dens
 real :: trans(6)
!
!--set up a cubic lattice of particles
!
 npartx = 50
 nparty = 50
 npartz = 50
 npart = npartx*nparty*npartz
 npixx = 100
 npixy = 100
 
 xmin = -0.5
 xmax = 0.5
 ymin = -0.5
 ymax = 0.5
 zmin = -0.5
 zmax = 0.5
 call setgrid(npartx,nparty,npartz,x,y,z,pmass,rho,h,weight,xmin,xmax,ymin,ymax,zmin,zmax)
! call pgopen('/xw')
! call pgenv(xmin,xmax,ymin,ymax,0,0)
! call pglabel('x','y',' ')
! call pgpt(npart,x,y,1)
! call pgenv(xmin,xmax,ymin,ymax,0,0)
! call pglabel('y','z',' ')
! call pgpt(npart,y,z,1)
! call pgenv(xmin,xmax,ymin,ymax,0,0)
! call pglabel('x','z',' ')
! call pgpt(npart,x,z,1)
!
!--setup integrated kernel table
!
 call setup_integratedkernel 
!
!--check value of the integration at q=zero (can do this analytically)
!
 print*,'coltable(0) = ',coltable(1),' should be ',2.*0.75/3.1415926536
!
!--now call interpolation routine to 10x10x10 pixels
!
 dxpix = (xmax-xmin)/real(npixx)
 call interpolate3D_projection(x(1:npart),y(1:npart),z(1:npart),h(1:npart), &
                               weight(1:npart),dat(1:npart),npart,xmin,ymin, &
                               datpix(1:npixx,1:npixy),npixx,npixy,dxpix,0.,0.)
!
!--check output
!
 dens = rho(1)
 columndens = dens*(zmax-zmin)
 call geterr(datpix(1:npixx,1:npixy),npixx,npixy,columndens,err)
 print "(70('-'))"
 print*,'average error in column density interpolation = ',err

! call pgenv(xmin,xmax,ymin,ymax,0,0)
! call pgpixl(datpix,npixx,npixy,1,npixx,1,npixy,xmin,xmax,ymin,ymax)
! trans = 0.
! trans(1) = xmin - 0.5*dxpix
! trans(2) = dxpix
! trans(4) = ymin - 0.5*dxpix
! trans(6) = dxpix
! call pgimag(datpix,npixx,npixy,1,npixx,1,npixy,0.0,1.0,trans)

!
!--take cross section at midplane and check density
!
 print "(70('-'))"
 call interpolate3D_fastxsec(x(1:npart),y(1:npart),z(1:npart), &
      h(1:npart),weight(1:npart),dat(1:npart),npart,&
      xmin,ymin,0.0,datpix(1:npixx,1:npixy),npixx,npixy,dxpix,.false.)     

 call geterr(datpix(1:npixx,1:npixy),npixx,npixy,dens,err)
 print*,'average error in normalised xsec interpolation = ',err
 print "(70('-'))"

 
! call pgenv(xmin,xmax,ymin,ymax,0,0)
! call pgpixl(datpix,npixx,npixy,1,npixx,1,npixy,xmin,xmax,ymin,ymax)
! trans = 0.
! trans(1) = xmin - 0.5*dxpix
! trans(2) = dxpix
! trans(4) = ymin - 0.5*dxpix
! trans(6) = dxpix
! call pgimag(datpix,npixx,npixy,1,npixx,1,npixy,0.0,1.0,trans)
! call pgend
!
!--take normalised cross section at midplane and check density
!
 call interpolate3D_fastxsec(x(1:npart),y(1:npart),z(1:npart), &
      h(1:npart),weight(1:npart),dat(1:npart),npart,&
      xmin,ymin,0.0,datpix(1:npixx,1:npixy),npixx,npixy,dxpix,.true.)     

 call geterr(datpix(1:npixx,1:npixy),npixx,npixy,dens,err)
 print*,'average error in normalised xsec interpolation = ',err
 print "(70('-'))"

 print*,'SPEED CHECKS...'
 
 npixx = 1
 npixy = 1
 npartx = idimx
 nparty = idimx
 npartz = idimx
 npart = npartx*nparty*npartz
 call setgrid(npartx,nparty,npartz,x,y,z,pmass,rho,h,weight,xmin,xmax,ymin,ymax,zmin,zmax)
 
 dxpix = (xmax-xmin)/real(npixx)
 call interpolate3D_projection(x(1:npart),y(1:npart),z(1:npart),h(1:npart), &
                               weight(1:npart),dat(1:npart),npart,xmin,ymin, &
                               datpix(1:npixx,1:npixy),npixx,npixy,dxpix,0.,0.)
 
 call geterr(datpix(1:npixx,1:npixy),npixx,npixy,columndens,err)
 print*,'average error in projection = ',err

 npixx = 1000
 npixy = 1000
 npartx = 2
 nparty = 2
 npartz = 2
 npart = npartx*nparty*npartz
 call setgrid(npartx,nparty,npartz,x,y,z,pmass,rho,h,weight,xmin,xmax,ymin,ymax,zmin,zmax)
 
 dxpix = (xmax-xmin)/real(npixx)
 call interpolate3D_projection(x(1:npart),y(1:npart),z(1:npart),h(1:npart), &
                               weight(1:npart),dat(1:npart),npart,xmin,ymin, &
                               datpix(1:npixx,1:npixy),npixx,npixy,dxpix,0.,0.)
 
 call geterr(datpix(1:npixx,1:npixy),npixx,npixy,columndens,err)
 print*,'average error in projection = ',err

contains

subroutine setgrid(npartx,nparty,npartz,x,y,z,pmass,rho,h,weight,xmin,xmax,ymin,ymax,zmin,zmax)
 implicit none
 integer , intent(in) :: npartx,nparty,npartz 
 real, dimension(:), intent(out) :: x,y,z,pmass,rho,h,weight
 real, intent(in) :: xmin,xmax,ymin,ymax,zmin,zmax
 integer :: ipart,k,j,i
 real :: dx,dy,dz,ypos,zpos
 real :: totmass,massp,vol,dens,h0
 
 dz = (zmax-zmin)/real(npartz - 1)
 dy = (ymax-ymin)/real(nparty - 1)
 dx = (xmax-xmin)/real(npartx - 1)
 ipart = 0
 
 do k=1,npartz
    zpos = zmin + (k-1)*dz
    do j=1,nparty
       ypos = ymin + (j-1)*dy
       do i=1,npartx
          ipart = ipart + 1
          x(ipart) = xmin + (i-1)*dx
          y(ipart) = ypos
          z(ipart) = zpos
!          print*,ipart,'x,y,z=',x(ipart),y(ipart),z(ipart)
       enddo
    enddo
 enddo
 
 npart = npartx*nparty*npartz
!
!--set other properties
!
 totmass = 1.0
 massp = totmass/real(npart)
 vol = (xmax-xmin)*(ymax-ymin)*(zmax-zmin)
 dens = totmass/vol
 h0 = 1.5*(massp/dens)**(1./3)
 print*,' testing ',npart,' particles in a cube configuration'
 print*,' dx = ',dx,' dy = ',dy,' dz = ',dz
 print*,' mass = ',massp,' dens = ',dens,' h = ',h0
 print*,' approx density = ',massp/(dx*dy*dz)
 do i = 1,npart
    pmass(i) = massp
    rho(i) = dens
    h(i) = h0
    dat(i) = rho(i)
    weight(i) = pmass(i)/(rho(i)*h(i)**3)
 enddo
  
end subroutine setgrid

subroutine geterr(datpix,npixx,npixy,datexact,err)
 implicit none
 integer, intent(in) :: npixx,npixy
 real, dimension(:,:), intent(in) :: datpix
 real, intent(in) :: datexact
 real, intent(out) :: err
 integer :: icalc,j,i
 real :: erri
 
 err = 0.
 icalc = 0
 do j=2,npixy-1
    do i=2,npixx-1
       icalc = icalc + 1
       erri = abs(datpix(i,j)-datexact)/datexact
       err = err + erri
       !if (erri.gt.0.05) print*,i,j,' xsec dens = ',datpix(i,j),' should be ',dens
    enddo
 enddo
 if (icalc.le.0) then
    print*,'cannot calculate error => npix too small'
    err = -1.0
 else
    err = err/real(icalc)
 endif
 
end subroutine geterr
 
end program test_interpolation