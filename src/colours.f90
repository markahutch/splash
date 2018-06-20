!-----------------------------------------------------------------
!
!  This file is (or was) part of SPLASH, a visualisation tool
!  for Smoothed Particle Hydrodynamics written by Daniel Price:
!
!  http://users.monash.edu.au/~dprice/splash
!
!  SPLASH comes with ABSOLUTELY NO WARRANTY.
!  This is free software; and you are welcome to redistribute
!  it under the terms of the GNU General Public License
!  (see LICENSE file for details) and the provision that
!  this notice remains intact. If you modify this file, please
!  note section 2a) of the GPLv2 states that:
!
!  a) You must cause the modified files to carry prominent notices
!     stating that you changed the files and the date of any change.
!
!  Copyright (C) 2005-2012 Daniel Price. All rights reserved.
!  Contact: daniel.price@monash.edu
!
!-----------------------------------------------------------------

!
! This module contains subroutines and variables for setting the
! colour schemes for rendered plots
!
module colours
 implicit none
 integer, parameter :: ncolourmax = 256
 integer, parameter :: ncolourschemes = 39
 character(len=17), dimension(ncolourschemes), parameter :: schemename = &
    (/'greyscale        ', &
      'red              ', &
      'Bate red-yellow  ', &
      'heat             ', &
      'rainbow          ', &
      'prism            ', &
      'red-blue-yellow  ', &
      'blue-yellow-red  ', &
      'purple-blue-green', &
      'gamma            ', &
      'gamma- no black  ', &
      'grn-red-blue-wht ', &
      'blk-blu-cyan-yell', &
      'rainbow II       ', &
      'rainbow II (casa)', &
      'haze             ', &
      'huesatval2       ', &
      'blue-red         ', &
      'blue-grn-red-yell', &
      'Bate BRY saoimage', &
      'ice (blue-white) ', &
      'fire             ', &
      'blue-red         ', &
      'menacing         ', &
      'rt               ', &
      'Dolag I          ', &
      'Dolag II         ', &
      'Dolag III        ', &
      'Alice WBYR       ', &
      'light blue       ', &
      'light green      ', &
      'light red        ', &
      'CMRmap           ', &
      'blue-black-red   ', &
      'inferno          ', &
      'viridis          ', &
      'ocean            ', &
      'casa blue        ', &
      'green-brown      '/)
  integer, parameter :: icustom = 100 ! number 100 is custom colour table
!
!--rgb colours of the colour table are stored in the array below
!  this is used for colour blending (opacity rendering)
!
  integer :: ifirstcolour, ncolours,ncoltable
  real, dimension(3,ncolourmax) :: rgbtable
  real, dimension(ncolourmax)   :: ltable

contains

! ------------------------------------------------------------------------
!      defines colour schemes for rendering
!      ** add your own here **
! ------------------------------------------------------------------------
subroutine colour_set(icolourscheme)
  use plotlib, only:plot_qcol,plot_qcir,plot_scir,plot_ctab,plot_scr,plot_qcr
  use settings_data, only:debugmode
  implicit none
  integer, intent(in) :: icolourscheme
  integer :: i,icolmin,icolmax,ncolmax,nset,index
  real :: brightness,contrast
  real, dimension(64) :: lumarr,redarr,greenarr,bluearr

  ncolours = ncolourmax-1
  nset = 0
!
!--set first colour index (warning: colours 1-16 have presets, so
!  overwriting these means that line graphs that use colour will come
!  out funny). Best to leave 0 and 1 alone as these are black and white.
!
  ifirstcolour = 2
!
!--inquire as to colour range available on current device
!  adjust ncolours if necessary
!
  call plot_qcol(icolmin,icolmax)
!  print*,' from device = ',icolmin,icolmax
  call plot_qcir(icolmin,icolmax)
!  print*,' other = ',icolmin,icolmax
  if (ifirstcolour.lt.icolmin) ifirstcolour = icolmin
  ncolmax = icolmax - ifirstcolour
  if (ncolours.gt.ncolmax) then
     ncolours = ncolmax
     print*,'Warning: Device allows only ',ncolours+1,' colours'
  endif
  !
  !--set this as the range of colour indices to use
  !
  if (debugmode) print*,'DEBUG: querying colour index range'
  call plot_scir(ifirstcolour,ifirstcolour+ncolours)

  brightness = 0.5
  contrast = 1.0
  !--invert colour table for negative values
  if (icolourscheme.lt.0) contrast = -1.0

  if (abs(icolourscheme).le.ncolourschemes) then
     select case(abs(icolourscheme))
     case(1)
     !--greyscale
     nset =  2
     lumarr(1:nset)  = (/0.000,1.000/)
     redarr(1:nset)  = (/0.000,1.000/)
     greenarr(1:nset)= (/0.000,1.000/)
     bluearr(1:nset) = (/0.000,1.000/)
     case(2)
     !--red temperature (IDL red-temperature)
     nset =  5
     lumarr(1:nset)  = (/0.000,0.475,0.694,0.745,1.000/)
     redarr(1:nset)  = (/0.000,0.686,1.000,1.000,1.000/)
     greenarr(1:nset)= (/0.000,0.004,0.420,0.518,1.000/)
     bluearr(1:nset) = (/0.000,0.000,0.000,0.000,1.000/)
     case(3)
     !--Bate red-yellow-white
     nset =  4
     lumarr(1:nset)  = (/0.000,0.337,0.666,1.000/)
     redarr(1:nset)  = (/0.000,1.000,1.000,1.000/)
     greenarr(1:nset)= (/0.000,0.000,1.000,1.000/)
     bluearr(1:nset) = (/0.000,0.000,0.000,1.000/)
     case(4)
     !--heat
     nset = 5
     lumarr(1:nset) =  (/0.,0.25,0.5,0.75,1.0/)
     redarr(1:nset) =  (/0.0,0.0,0.0,1.0,1.0/)
     greenarr(1:nset)= (/0.0,1.0,1.0,1.0,0.0/)
     bluearr(1:nset) = (/1.0,1.0,0.0,0.0,0.0/)
     case(5)
     !--rainbow
     nset = 8
     lumarr(1:nset) =  (/0.0,0.125,0.225,0.25,0.425,0.625,0.8125,1.0/)
     redarr(1:nset) =  (/0.0,0.341,0.100,0.00,0.000,0.000,1.0000,1.0/)
     greenarr(1:nset)= (/0.0,0.000,0.000,0.00,1.000,1.000,1.0000,0.0/)
     bluearr(1:nset) = (/0.0,0.569,1.000,1.00,1.000,0.000,0.0000,0.0/)
     case(6)
     !--prism (IDL prism)
     nset =  8
     lumarr(1:nset)  = (/0.000,0.251,0.263,0.494,0.502,0.749,0.753,1.000/)
     redarr(1:nset)  = (/0.000,0.953,1.000,0.035,0.000,0.000,0.000,0.000/)
     greenarr(1:nset)= (/0.000,0.000,0.043,0.969,1.000,0.000,0.000,0.000/)
     bluearr(1:nset) = (/0.000,0.000,0.000,0.000,0.027,0.984,1.000,0.000/)
     case(7)
     !--red-blue-yellow (IDL 16: stern special)
     nset =  7
     lumarr(1:nset)  = (/0.000,0.055,0.247,0.251,0.502,0.737,1.000/)
     redarr(1:nset)  = (/0.000,0.996,0.000,0.251,0.502,0.737,1.000/)
     greenarr(1:nset)= (/0.000,0.055,0.247,0.251,0.502,0.737,1.000/)
     bluearr(1:nset) = (/0.000,0.106,0.490,0.498,1.000,0.000,1.000/)
     case(8)
     !--blue-yellow-red (IDL 34: blue-red)
     nset = 10
     lumarr(1:nset)  = (/0.000,0.004,0.125,0.129,0.380,0.384,0.635,0.886,0.996,1.000/)
     redarr(1:nset)  = (/0.000,0.000,0.000,0.000,0.000,0.000,1.000,1.000,0.514,0.514/)
     greenarr(1:nset)= (/0.000,0.000,0.000,0.000,1.000,1.000,1.000,0.000,0.000,0.000/)
     bluearr(1:nset) = (/0.514,0.514,1.000,1.000,1.000,1.000,0.000,0.000,0.000,0.000/)
!     nset = 6
!     lumarr(1:nset) =  (/0.0,0.2,0.4,0.6,0.8,1.0/)
!     redarr(1:nset) =  (/0.0,0.0,0.5,1.0,1.0,0.5/)
!     bluearr(1:nset) = (/1.0,1.0,0.5,0.0,0.0,0.0/)
!     greenarr(1:nset)= (/0.0,1.0,0.5,1.0,0.0,0.0/)
     case(9)
     !--purple-blue-green
     nset = 6
     lumarr(1:nset) =  (/0.0,0.1,0.2,0.5,0.8,1.0/)
     redarr(1:nset) =  (/0.0,0.1,0.5,0.02,0.0,0.0/)
     bluearr(1:nset) = (/0.0,0.2,0.5,0.98,0.0,0.0/)
     greenarr(1:nset)= (/0.0,0.0,0.0,0.0,0.62,0.98/)
     case(10)
     !--gamma (IDL 6: stdgamma-ii)
     nset = 18
     lumarr(1:nset)  =(/0.,0.184,0.192,0.251,0.31,0.376,0.427,0.431,0.443,0.502,0.569,0.624,0.635,0.682,0.69,0.749,0.753,1./)
     redarr(1:nset)  =(/0.,0.000,0.035,0.318,0.31,0.643,0.914,1.000,1.000,1.000,1.000,1.000,1.000,0.639,0.678,0.976,1.00,1./)
     greenarr(1:nset)=(/0.,0.000,0.000,0.000,0.00,0.000,0.000,0.000,0.000,0.318,0.639,0.639,0.639,0.639,0.639,1.000,1.00,1./)
     bluearr(1:nset) =(/0.,0.957,1.000,0.682,0.365,0.00,0.000,0.000,0.000,0.000,0.322,0.000,0.000,0.000,0.000,0.188,0.20,1./)
     case(11)
     !--gamma but without the fade to black
     nset = 18
     lumarr(1:nset)  =(/0.,0.184,0.192,0.251,0.31,0.376,0.427,0.431,0.443,0.502,0.569,0.624,0.635,0.682,0.69,0.749,0.753,1./)
     redarr(1:nset)  =(/0.,0.000,0.035,0.318,0.31,0.643,0.914,1.000,1.000,1.000,1.000,1.000,1.000,0.639,0.678,0.976,1.00,1./)
     greenarr(1:nset)=(/0.,0.000,0.000,0.000,0.00,0.000,0.000,0.000,0.000,0.318,0.639,0.639,0.639,0.639,0.639,1.000,1.00,1./)
     bluearr(1:nset) =(/0.5,0.957,1.000,0.682,0.365,0.00,0.000,0.000,0.000,0.000,0.322,0.000,0.000,0.000,0.000,0.188,0.20,1./)
     case(12)
     !--IDL 3: grn-red-blu-wht
     nset = 13
     lumarr(1:nset)  = (/0.000,0.008,0.047,0.110,0.125,0.267,0.282,0.298,0.773,0.788,0.863,0.988,1.000/)
     redarr(1:nset)  = (/0.000,0.000,0.000,0.000,0.094,0.941,0.988,0.988,0.643,0.639,0.580,0.988,1.000/)
     greenarr(1:nset)= (/0.000,0.282,0.424,0.988,0.941,0.094,0.000,0.000,0.000,0.000,0.000,0.988,1.000/)
     bluearr(1:nset) = (/0.000,0.000,0.000,0.000,0.000,0.000,0.000,0.004,0.984,1.000,1.000,1.000,1.000/)
     case(13)
     !--black-blue-cyan-yellow
     nset = 4
     lumarr(1:nset) =  (/0.,0.333,0.666,1.0/)
     redarr(1:nset) =  (/0.0,0.0,0.0,1.0/)
     greenarr(1:nset)= (/0.0,0.0,1.0,1.0/)
     bluearr(1:nset) = (/0.0,1.0,1.0,0.0/)
     case(14)
     !--rainbow II (as used in NS merger I)
     nset = 10
     lumarr(1:nset)  = (/0.000,0.153,0.157,0.310,0.314,0.467,0.471,0.624,0.627,1.000/)
     redarr(1:nset)  = (/1.000,1.000,0.996,0.016,0.000,0.000,0.000,0.000,0.020,1.000/)
     greenarr(1:nset)= (/0.000,0.980,1.000,1.000,1.000,1.000,0.984,0.004,0.000,0.000/)
     bluearr(1:nset) = (/0.000,0.000,0.000,0.000,0.012,0.988,1.000,1.000,1.000,1.000/)
     case(15) ! rainbow scheme from CASA
     nset = 56
     lumarr(1:nset)  = (/0.000,0.008,0.016,0.035,0.051,0.062,0.070,0.082,0.094,0.105,&
                         0.113,0.137,0.152,0.160,0.172,0.184,0.191,0.203,0.215,0.227,&
                         0.234,0.258,0.277,0.285,0.309,0.328,0.336,0.406,0.430,0.457,&
                         0.480,0.520,0.570,0.602,0.609,0.621,0.629,0.637,0.648,0.656,&
                         0.668,0.680,0.754,0.762,0.770,0.777,0.793,0.801,0.812,0.820,&
                         0.844,0.852,0.867,0.875,0.941,1.000/)
     redarr(1:nset)  = (/0.000,0.055,0.102,0.235,0.325,0.384,0.455,0.494,0.404,0.341,&
                         0.282,0.149,0.043,0.000,0.004,0.012,0.024,0.047,0.106,0.133,&
                         0.157,0.200,0.224,0.247,0.271,0.302,0.318,0.420,0.443,0.486,&
                         0.514,0.561,0.510,0.557,0.600,0.659,0.737,0.800,0.894,0.969,&
                         0.988,1.000,0.996,0.992,0.969,0.945,0.918,0.898,0.882,0.875,&
                         0.859,0.859,0.855,0.847,0.725,0.635/)
     greenarr(1:nset)= (/0.000,0.000,0.000,0.000,0.000,0.000,0.000,0.000,0.000,0.000,&
                         0.000,0.000,0.000,0.000,0.016,0.039,0.078,0.125,0.184,0.231,&
                         0.275,0.353,0.400,0.435,0.478,0.533,0.565,0.745,0.788,0.863,&
                         0.910,0.992,0.875,0.804,0.776,0.776,0.812,0.839,0.886,0.925,&
                         0.961,1.000,0.988,0.969,0.886,0.788,0.659,0.549,0.455,0.349,&
                         0.180,0.114,0.031,0.000,0.000,0.000/)
     bluearr(1:nset) = (/0.000,0.208,0.239,0.333,0.404,0.451,0.502,0.545,0.620,0.667,&
                         0.722,0.843,0.922,0.961,0.925,0.875,0.816,0.769,0.702,0.655,&
                         0.616,0.529,0.467,0.435,0.388,0.337,0.310,0.188,0.188,0.204,&
                         0.216,0.235,0.208,0.184,0.180,0.184,0.188,0.196,0.208,0.216,&
                         0.227,0.235,0.231,0.227,0.208,0.184,0.153,0.129,0.106,0.067,&
                         0.016,0.004,0.000,0.000,0.000,0.000,0.208/)
    !--rainbow III
!     nset = 13
!     lumarr(1:nset)  = (/0.000,0.004,0.110,0.114,0.333,0.557,0.561,0.565,0.569,0.776,0.780,0.996,1.000/)
!     redarr(1:nset)  = (/0.486,0.486,0.012,0.000,0.000,0.004,0.020,0.051,0.055,0.992,1.000,1.000,1.000/)
!     greenarr(1:nset)= (/0.000,0.000,0.000,0.008,0.996,1.000,1.000,1.000,1.000,1.000,0.988,0.020,0.020/)
!    bluearr(1:nset) = (/1.000,1.000,1.000,1.000,1.000,0.000,0.000,0.000,0.000,0.000,0.000,0.000,0.000/)
     case(16)
     !--haze (IDL 17: haze)
!     nset = 11
!     lumarr(1:nset)  = (/0.000,0.008,0.016,0.486,0.494,0.502,0.514,0.953,0.961,0.996,1.000/)
!     redarr(1:nset)  = (/0.655,1.000,0.976,0.047,0.031,0.016,0.027,0.898,0.914,0.984,0.984/)
!     greenarr(1:nset)= (/0.439,0.835,0.824,0.161,0.149,0.137,0.122,0.706,0.718,0.765,0.765/)
!     bluearr(1:nset) = (/1.000,0.996,0.980,0.510,0.502,0.494,0.482,0.043,0.035,0.000,0.000/)
     !--without the bottom colour
     nset = 11
     lumarr(1:nset)  = (/0.000,0.008,0.016,0.486,0.494,0.502,0.514,0.953,0.961,0.996,1.000/)
     redarr(1:nset)  = (/1.000,1.000,0.976,0.047,0.031,0.016,0.027,0.898,0.914,0.984,0.984/)
     greenarr(1:nset)= (/0.835,0.835,0.824,0.161,0.149,0.137,0.122,0.706,0.718,0.765,0.765/)
     bluearr(1:nset) = (/1.000,0.996,0.980,0.510,0.502,0.494,0.482,0.043,0.035,0.000,0.000/)
     case(17)
     !--huesatval
     nset = 11
     lumarr(1:nset)  = (/0.000,0.506,0.514,0.675,0.682,0.843,0.851,0.961,0.969,0.996,1.000/)
     redarr(1:nset)  = (/1.000,0.494,0.486,0.329,0.345,0.988,1.000,1.000,1.000,1.000,1.000/)
     greenarr(1:nset)= (/0.992,0.992,1.000,1.000,1.000,1.000,0.969,0.345,0.294,0.114,0.114/)
     bluearr(1:nset) = (/0.992,1.000,0.980,0.337,0.322,0.161,0.153,0.043,0.035,0.008,0.008/)
     case(18)
     !--blue-red2 (IDL 12: blue-red)
     nset = 10
     lumarr(1:nset)  = (/0.000,0.016,0.247,0.255,0.498,0.506,0.749,0.757,0.996,1.000/)
     redarr(1:nset)  = (/0.000,0.000,0.000,0.000,0.000,0.016,1.000,1.000,1.000,1.000/)
     greenarr(1:nset)= (/0.000,0.016,1.000,0.984,0.000,0.000,0.000,0.000,0.000,0.000/)
     bluearr(1:nset) = (/0.000,0.016,1.000,1.000,1.000,1.000,1.000,0.984,0.000,0.000/)
     case(19)
     !--blue-green-red-yellow (IDL 5: blue-green-red-yellow)
     nset =  8
     lumarr(1:nset)  = (/0.000,0.125,0.188,0.314,0.439,0.502,0.565,1.000/)
     redarr(1:nset)  = (/0.000,0.000,0.000,0.000,0.000,0.471,0.784,1.000/)
     greenarr(1:nset)= (/0.000,0.000,0.196,0.588,0.549,0.392,0.000,1.000/)
     bluearr(1:nset) = (/0.000,0.259,0.392,0.392,0.000,0.000,0.000,0.000/)
     case(20)
     !--Bate BRY saoimage
     nset =  5
     lumarr(1:nset)  = (/0.000,0.25,0.50,0.75,1.00/)
     redarr(1:nset)  = (/0.000,0.00,1.00,1.00,1.00/)
     greenarr(1:nset)= (/0.000,0.00,0.00,1.00,1.00/)
     bluearr(1:nset) = (/0.000,1.00,0.00,0.00,1.00/)
!     !--Bate BRY original
!     nset =  5
!     lumarr(1:nset)  = (/0.000,0.195,0.586,0.781,1.00/)
!     redarr(1:nset)  = (/0.000,0.000,1.000,1.000,1.00/)
!     greenarr(1:nset)= (/0.000,0.000,0.000,1.000,1.00/)
!     bluearr(1:nset) = (/0.000,1.000,0.000,0.000,1.00/)
     case(21)
     !--ice blue (IDL blue-white)
     nset =  5
     lumarr(1:nset)  = (/0.000,0.376,0.737,0.753,1.000/)
     redarr(1:nset)  = (/0.000,0.000,0.000,0.000,1.000/)
     greenarr(1:nset)= (/0.000,0.000,0.580,0.604,1.000/)
     bluearr(1:nset) = (/0.000,0.510,1.000,1.000,1.000/)
     case(22)
     !--fire (from FLASH code)
     nset =  6
     lumarr(1:nset)  = (/0.000,0.016,0.078,0.643,0.800,1.000/)
     redarr(1:nset)  = (/1.000,1.000,1.000,1.000,0.000,0.973/)
     greenarr(1:nset)= (/0.000,0.039,0.129,0.957,0.357,0.980/)
     bluearr(1:nset) = (/0.000,0.000,0.000,0.000,0.000,0.973/)
     case(23)
     !--blue-red (from FLASH code)
     nset =  7
     lumarr(1:nset)  = (/0.000,0.149,0.345,0.541,0.643,0.769,1.000/)
     redarr(1:nset)  = (/0.000,0.000,0.157,0.792,0.894,0.988,0.996/)
     greenarr(1:nset)= (/0.063,0.271,0.584,0.800,0.427,0.220,0.004/)
     bluearr(1:nset) = (/0.173,0.722,0.153,0.153,0.082,0.165,0.000/)
     case(24)
     !--menacing (from FLASH code)
     nset = 22
     lumarr(1:nset)  = (/0.000,0.078,0.133,0.161,0.169,0.263,0.271,0.302, &
                         0.357,0.455,0.478,0.514,0.545,0.588,0.612,0.624, &
                         0.643,0.722,0.749,0.796,0.808,1.000/)
     redarr(1:nset)  = (/0.388,1.000,0.757,0.953,0.949,0.859,0.906,1.000, &
                         1.000,0.196,0.098,0.004,0.000,0.000,0.000,0.000, &
                         0.000,0.051,0.278,0.561,0.612,0.988/)
     greenarr(1:nset)= (/0.000,0.000,0.118,0.318,0.306,0.749,0.792,1.000, &
                         1.000,0.490,0.420,0.220,0.125,0.906,0.718,0.569, &
                         0.000,0.000,0.004,0.008,0.000,0.973/)
     bluearr(1:nset) = (/0.000,0.000,0.024,0.051,0.059,0.173,0.157,0.000, &
                         0.000,0.086,0.063,0.004,0.000,0.941,0.827,0.725, &
                         0.322,0.302,0.518,0.635,0.600,0.988/)
     case(25)
     !--RT (from FLASH code)
     nset =  6
     lumarr(1:nset)  = (/0.000,0.455,0.580,0.765,0.773,1.000/)
     redarr(1:nset)  = (/0.220,1.000,1.000,1.000,1.000,1.000/)
     greenarr(1:nset)= (/0.000,0.000,0.478,0.980,1.000,1.000/)
     bluearr(1:nset) = (/0.000,0.000,0.000,0.588,0.608,0.737/)
     case(26)
!     !--these are Klaus Dolag colour schemes
     nset = 3
     !--blue-green-red ("highlight")
     lumarr(1:nset) =   (/0.0,0.5,1.0/)
     redarr(1:nset) =   (/0.0,0.5,1.0/)
     greenarr(1:nset) = (/0.0,1.0,0.0/)
     bluearr(1:nset) =  (/1.0,0.5,0.0/)
     case(27)
     nset = 3
     !--red-greeny-blue
     lumarr(1:nset) =   (/0.0,0.5,1.0/)
     redarr(1:nset) =   (/1.0,0.66,0.0/)
     greenarr(1:nset) = (/0.0,0.66,0.0/)
     bluearr(1:nset) =  (/0.0,0.66,1.0/)
     case(28)
     nset = 5
     !--dolag other
     lumarr(1:nset) =   (/0.0,0.33,0.5,0.66,1.0/)
     redarr(1:nset) =   (/0.0,1.00,0.5,0.00,1.0/)
     greenarr(1:nset) = (/0.0,0.66,1.0,0.66,0.0/)
     bluearr(1:nset) =  (/1.0,0.66,0.5,0.33,0.0/)
     case(29)
     !--Alice WBYR
     nset = 12
     lumarr(1:nset) = (/0.0,0.002,0.00672,0.01344,0.40824,0.41496,0.42168,0.43176,0.80052,0.80724,0.84,1.0/)
     redarr(1:nset) = (/1.0,1.0,1.0,0.976,0.047,0.031,0.016,0.027,0.898,0.914,0.984,0.996/)
     greenarr(1:nset) = (/1.0,0.835,0.835,0.824,0.161,0.149,0.137,0.122,0.706,0.718,0.765,0.055/)
     bluearr(1:nset) = (/1.0,1.0,0.996,0.980,0.510,0.502,0.494,0.482,0.043,0.035,0.0,0.0/)
     case(30)
     nset = 6
     !--light blue
     lumarr(1:nset) =   (/0.0,0.125,0.25,0.5,0.75,1.0/)
     redarr(1:nset) =   (/0.000,0.00,0.00,0.300,0.700,1.000/)
     greenarr(1:nset) = (/0.145,0.25,0.36,0.612,0.816,1.000/)
     bluearr(1:nset) =  (/0.350,0.54,0.65,0.800,0.918,1.000/)
     case(31)
     nset = 6
     !--light green
     lumarr(1:nset) =   (/0.0,0.125,0.25,0.5,0.75,1.0/)
     redarr(1:nset) =   (/0.00,0.0,0.075,0.37,0.73,1.000/)
     greenarr(1:nset) = (/0.20,0.353,0.471,  0.718,0.895,1.000/)
     bluearr(1:nset) =  (/0.082,0.13,0.21,   0.384,0.700,1.000/)
     case(32)
     !--light red
     nset =  7
     lumarr(1:nset)  = (/0.00,0.13,0.25,0.4,0.50,0.75,1.00/)
     redarr(1:nset)  = (/0.44,0.60,0.84,1.0,1.00,1.00,1.00/)
     greenarr(1:nset)= (/0.11,0.15,0.21,0.35,0.50,0.75,1.00/)
     bluearr(1:nset) = (/0.00,0.00,0.00,0.00,0.15,0.55,1.00/)
     case(33)
     nset = 9
     !--from Carey Rappaport
     ! "A colormap for effective black and white rendering of color scale images"
     ! IEEE Antennas Propagat. Mag. vol. 44, no. 3, pp 94-96, Jun 2002.
     lumarr(1:nset) =   (/0.0,0.125,0.25,0.375,0.5,0.625,0.75,0.875,1.0/)
     redarr(1:nset) =   (/0.00,0.15,0.30,0.60,1.00,0.90,0.90,0.90,1.00/)
     greenarr(1:nset) = (/0.00,0.15,0.15,0.20,0.25,0.50,0.75,0.90,1.00/)
     bluearr(1:nset) =  (/0.00,0.50,0.75,0.50,0.15,0.00,0.10,0.50,1.00/)
     case(34)
     !--heat but with black in the middle
     nset = 5
     lumarr(1:nset) =  (/0.,0.25,0.5,0.75,1.0/)
     redarr(1:nset) =  (/0.0,0.0,0.0,1.0,0.95/)
     greenarr(1:nset)= (/0.0,1.0,0.0,1.0,0.0/)
     bluearr(1:nset) = (/0.95,1.0,0.0,0.0,0.0/)
     case(35)
     !--inferno
     nset = 32
     lumarr(1:nset) = (/0.000000, &
     0.032258,0.064516,0.096774,0.129032,0.161290,0.193548,0.225806,0.258065, &
     0.290323,0.322581,0.354839,0.387097,0.419355,0.451613,0.483871,0.516129, &
     0.548387,0.580645,0.612903,0.645161,0.677419,0.709677,0.741935,0.774194, &
     0.806452,0.838710,0.870968,0.903226,0.935484,0.967742,1.000000/)
     redarr(1:nset) = (/0.001462, &
     0.013995,0.042253,0.081962,0.135778,0.190367,0.244967,0.297178,0.354032, &
     0.403894,0.453651,0.503493,0.559624,0.609330,0.658463,0.706500,0.758422, &
     0.801871,0.841969,0.878001,0.912966,0.938675,0.959114,0.974176,0.984591, &
     0.987926,0.985566,0.977497,0.962517,0.948683,0.951740,0.988362/)
     greenarr(1:nset) = (/0.000466, &
     0.011225,0.028139,0.043328,0.046856,0.039309,0.037055,0.047470,0.066925, &
     0.085580,0.103848,0.121575,0.141346,0.159474,0.178962,0.200728,0.229097, &
     0.258674,0.292933,0.332060,0.381636,0.430091,0.482014,0.536780,0.601122, &
     0.660250,0.720782,0.782258,0.851476,0.910473,0.960587,0.998364/)
     bluearr(1:nset) = (/0.013866, &
     0.071862,0.141141,0.215289,0.299776,0.361447,0.400007,0.420491,0.430906, &
     0.433179,0.430498,0.423356,0.410078,0.393589,0.372748,0.347777,0.315266, &
     0.283099,0.248564,0.212268,0.169755,0.130438,0.089499,0.048392,0.023606, &
     0.051750,0.112229,0.185923,0.285546,0.395289,0.524203,0.644924/)
     case(36)
     !--viridis
     nset = 32
     lumarr(1:nset) = (/0.000000, &
     0.032258,0.064516,0.096774,0.129032,0.161290,0.193548,0.225806,0.258065, &
     0.290323,0.322581,0.354839,0.387097,0.419355,0.451613,0.483871,0.516129, &
     0.548387,0.580645,0.612903,0.645161,0.677419,0.709677,0.741935,0.774194, &
     0.806452,0.838710,0.870968,0.903226,0.935484,0.967742,1.000000/)
     redarr(1:nset) = (/0.267004, &
     0.277018,0.282327,0.282884,0.278012,0.269308,0.257322,0.243113,0.225863, &
     0.210503,0.195860,0.182256,0.168126,0.156270,0.144759,0.133743,0.123463, &
     0.119423,0.124780,0.143303,0.180653,0.226397,0.281477,0.344074,0.421908, &
     0.496615,0.575563,0.657642,0.751884,0.835270,0.916242,0.993248/)
     greenarr(1:nset) = (/0.004874, &
     0.050344,0.094955,0.135920,0.180367,0.218818,0.256130,0.292092,0.330805, &
     0.363727,0.395433,0.426184,0.459988,0.489624,0.519093,0.548535,0.581687, &
     0.611141,0.640461,0.669459,0.701402,0.728888,0.755203,0.780029,0.805774, &
     0.826376,0.844566,0.860219,0.874951,0.886029,0.896091,0.906157/)
     bluearr(1:nset) = (/0.329415, &
     0.375715,0.417331,0.453427,0.486697,0.509577,0.526563,0.538516,0.547314, &
     0.552206,0.555276,0.557120,0.558082,0.557936,0.556572,0.553541,0.547445, &
     0.538982,0.527068,0.511215,0.488189,0.462789,0.432552,0.397381,0.351910, &
     0.306377,0.256415,0.203082,0.143228,0.102646,0.100717,0.143936/)
     case(37)
     !--ocean (cut from pyplot colormap terrain from 0->0.25)
     nset = 32
     lumarr(1:nset) = (/0.000000, &
     0.032258,0.064516,0.096774,0.129032,0.161290,0.193548,0.225806,0.258065, &
     0.290323,0.322581,0.354839,0.387097,0.419355,0.451613,0.483871,0.516129, &
     0.548387,0.580645,0.612903,0.645161,0.677419,0.709677,0.741935,0.774194, &
     0.806452,0.838710,0.870968,0.903226,0.935484,0.967742,1.000000/)
     redarr(1:nset) = (/0.2, &
     0.18954248,0.17908497,0.16862745,0.15816993,0.14771242,0.1372549 ,0.12679739,0.11633987, &
     0.10588235,0.09542484,0.08496732,0.0745098 ,0.06405229,0.05359477,0.04313725,0.02745098, &
     0.01699346,0.00653595,0.        ,0.        ,0.        ,0.        ,0.        ,0.        , &
     0.        ,0.        ,0.        ,0.        ,0.        ,0.        ,0.00392157/)
     greenarr(1:nset) = (/0.2, &
     0.22091503,0.24183007,0.2627451 ,0.28366013,0.30457516,0.3254902 ,0.34640523,0.36732026, &
     0.38823529,0.40915033,0.43006536,0.45098039,0.47189542,0.49281046,0.51372549,0.54509804, &
     0.56601307,0.5869281 ,0.60588235,0.62156863,0.6372549 ,0.65294118,0.66862745,0.68431373, &
     0.7       ,0.71568627,0.73137255,0.74705882,0.7627451 ,0.77843137,0.80078431 /)
     bluearr(1:nset) = (/0.6, &
     0.62091503,0.64183007,0.6627451 ,0.68366013,0.70457516,0.7254902 ,0.74640523,0.76732026, &
     0.78823529,0.80915033,0.83006536,0.85098039,0.87189542,0.89281046,0.91372549,0.94509804, &
     0.96601307,0.9869281 ,0.98235294,0.93529412,0.88823529,0.84117647,0.79411765,0.74705882, &
     0.7       ,0.65294118,0.60588235,0.55882353,0.51176471,0.46470588,0.40078431/)
     case(38)
     !--casa blue
     nset = 28
     lumarr(1:nset)  = (/0.000,0.012,0.020,0.047,0.055,0.082,0.098,0.109,0.152,0.168,&
                         0.180,0.223,0.273,0.305,0.375,0.395,0.402,0.426,0.496,0.504,&
                         0.574,0.598,0.605,0.676,0.781,0.848,0.992,1.000/)
     redarr(1:nset)  = (/0.996,0.957,0.918,0.816,0.796,0.706,0.655,0.620,0.518,0.471,&
                         0.447,0.369,0.286,0.247,0.173,0.157,0.145,0.133,0.090,0.078,&
                         0.039,0.031,0.027,0.016,0.004,0.000,0.000,0.000/)
     greenarr(1:nset)= (/0.996,0.957,0.918,0.816,0.796,0.706,0.655,0.620,0.518,0.471,&
                         0.447,0.369,0.286,0.247,0.173,0.157,0.145,0.133,0.090,0.078,&
                         0.039,0.031,0.027,0.016,0.004,0.000,0.000,0.000/)
     bluearr(1:nset) = (/1.000,0.988,0.976,0.941,0.937,0.910,0.886,0.878,0.835,0.816,&
                         0.804,0.761,0.714,0.682,0.612,0.592,0.580,0.561,0.494,0.482,&
                         0.416,0.400,0.384,0.318,0.231,0.165,0.008,0.000/)
     case(39)
     !--green-grey-brown
     nset = 3
     lumarr(1:nset) =   (/0.0,0.5,1.0/)
     redarr(1:nset) =   (/0.0,0.66,0.5/)
     greenarr(1:nset) = (/0.83,0.66,0.33/)
     bluearr(1:nset) =  (/0.33,0.66,0.17/)
     end select

     if (debugmode) print*,'DEBUG: setting colour table'
     call plot_ctab(lumarr(1:nset),redarr(1:nset),greenarr(1:nset),bluearr(1:nset), &
                 nset,contrast,brightness)
  endif
!
!--if icolourscheme = ncolourschemes+1 set the PGPLOT colour indices
!  from the contents of the rgbtable array
!
  if (abs(icolourscheme).eq.icustom) then
     print "(1x,a)",'using colour scheme other'
     !
     !--for giza we have to call set_ctab directly with all 256 colours
     !
     do i=1,ncoltable
        ltable(i) = (i-1)/real(ncoltable-1)
     enddo
     nset = ncoltable
     call plot_ctab(ltable(1:nset),rgbtable(1,1:nset),rgbtable(2,1:nset),rgbtable(3,1:nset), &
                    nset,contrast,brightness)

     ! for pgplot we set the colours in the colour table individually
     ncolours = ncoltable-1
     call plot_scir(ifirstcolour,ifirstcolour+ncolours)
     do i=1,ncolours
        index = ifirstcolour + (i-1)
        call plot_scr(index,rgbtable(1,i),rgbtable(2,i),rgbtable(3,i))
     enddo

  elseif (abs(icolourscheme).le.ncolourschemes) then
!
!--also store the colour table as a list of r,g,b values
!
     if (debugmode) print*,'DEBUG: querying colour table'
     do i=1,ncolours+1
        index = ifirstcolour + (i-1)
        call plot_qcr(index,rgbtable(1,i),rgbtable(2,i),rgbtable(3,i))
     enddo

     if (icolourscheme.lt.0) then
        print "(1x,a)",'using colour scheme inverse '//trim(schemename(abs(icolourscheme)))
     else
        print "(1x,a)",'using colour scheme '//trim(schemename(icolourscheme))
     endif
  else
     print "(1x,a)",'warning: unknown colour scheme - uses default greyscale'

  endif
  if (debugmode) print*,'DEBUG: finished colour_set'

  return

end subroutine colour_set

!------------------------------------------------
! demonstration plot of all the colour schemes
!------------------------------------------------
subroutine colour_demo
  implicit none
!  integer :: i,j,nc
  !
  !--npixx should be >= ncolours in setcolours.f
  !
!  integer, parameter :: npixx = ncolourmax
!  integer, parameter :: npixy = npixx/10
!  real, dimension(npixx,npixy) :: sample
!  real :: xmin,xmax,ymin,ymax,dx,dy,trans(6)
!  character(len=10) :: string

!  call pgbegin(0,'?',1,ncolourschemes)
!!  call pgpaper(6.0,8.0) !!!0.25/sqrt(2.))

!  xmin = 0.0
!  xmax = 1.0
!  ymin = 0.0
!  ymax = 0.1
!  dx = (xmax-xmin)/float(npixx)
!  dy = (ymax-ymin)/float(npixy)
!  trans(1) = xmin - 0.5*dx
!  trans(2) = dx
!  trans(3) = 0.0
!  trans(4) = ymin - 0.5*dy
!  trans(5) = 0.0
!  trans(6) = dy

!  do j=1,npixy
!     do i=1,npixx
!        sample(i,j) = (i-1)*dx
!     enddo
!  enddo
!!  call pgsch(2.0)
!!  call pgenv(xmin,xmax,ymin,ymax,0,-1)
!!  call pgsch(1.0)
!!  call pggray(sample,npixx,npixy,1,npixx,1,npixy, &
!!              minval(sample),maxval(sample),trans)
!!  call pgnumb(1,0,0,string,nc)
!!  call pgsch(7.0)
!!  call pgmtxt('t',0.5,0.5,0.5,string(1:nc)//': '//trim(schemename(1)))

!  do i=1,ncolourschemes
!     call pgsch(2.0)
!     call pgenv(xmin,xmax,ymin,ymax,0,-1)
!     call pgsch(7.0)
!     call pgnumb(i,0,0,string,nc)
!     call pgmtxt('t',0.5,0.5,0.5,string(1:nc)//': '//trim(schemename(i)))
!     call colour_set(i)
!     call pgimag(sample,npixx,npixy,1,npixx,1,npixy, &
!                 minval(sample),maxval(sample),trans)
!  enddo

!  call pgsch(1.0)
!  call pgend

end subroutine colour_demo


end module colours
