DEBUG = -fbounds-check -g 
OPT    =-O3

# these three lines should be edited for your system. On systems 
# that do not have separate fortran and c libraries, set NETCDF_FOR and NETCDF_C
# to the same, and set NETCDF_LIB to -lnetcdf (i.e. without the extra f)
#NETCDF_FOR=/Users/mccikpc2/Dropbox/programming/netcdf-4.4.4-mac/
#NETCDF_C=/Users/mccikpc2/Dropbox/programming/netcdf-4.4.1.1-mac/
NETCDF_LIB=-lnetcdff 

NETCDFLIB=-L ${NETCDF_FOR}/lib/  \
          -L ${NETCDF_C}/lib/
NETCDFMOD= ${NETCDF_FOR}/include/


FOR = mpif90 -c  
FOR2 = mpif90  

AR = ar 
RANLIB = ranlib 
OBJ = o
FFLAGS = $(OPT)  $(DEBUG) -w -fallow-argument-mismatch -o 
FFLAGS2 =  $(DEBUG) -w -fallow-argument-mismatch -O3 -o 

main.exe	:  model_lib.a  main.$(OBJ) variables.$(OBJ) initialisation.$(OBJ) \
				mpi_module.$(OBJ) driver_code.$(OBJ) advection.$(OBJ)
	$(FOR2) $(FFLAGS2)main.exe main.$(OBJ) variables.$(OBJ) initialisation.$(OBJ) \
			 mpi_module.$(OBJ) driver_code.$(OBJ) advection.$(OBJ) -lm model_lib.a \
		${NETCDFLIB} -I ${NETCDFMOD} ${NETCDF_LIB} $(DEBUG)
model_lib.a	:   nrtype.$(OBJ) nr.$(OBJ) nrutil.$(OBJ) locate.$(OBJ) polint.$(OBJ) \
				rkqs.$(OBJ) rkck.$(OBJ) odeint.$(OBJ) zbrent.$(OBJ) \
				hygfx.$(OBJ)  random.$(OBJ)
	$(AR) rc model_lib.a nrutil.$(OBJ) locate.$(OBJ) polint.$(OBJ) \
				rkqs.$(OBJ) rkck.$(OBJ) odeint.$(OBJ) zbrent.$(OBJ) \
				hygfx.$(OBJ)  random.$(OBJ)
locate.$(OBJ)	: locate.f90
	$(FOR) locate.f90 $(FFLAGS)locate.$(OBJ)
polint.$(OBJ)	: polint.f90
	$(FOR) polint.f90 $(FFLAGS)polint.$(OBJ)
nrtype.$(OBJ)	: nrtype.f90
	$(FOR) nrtype.f90 $(FFLAGS)nrtype.$(OBJ)
nr.$(OBJ)	: nr.f90 
	$(FOR) nr.f90 $(FFLAGS)nr.$(OBJ)
nrutil.$(OBJ)	: nrutil.f90
	$(FOR) nrutil.f90 $(FFLAGS)nrutil.$(OBJ)
rkqs.$(OBJ)	: rkqs.f90
	$(FOR) rkqs.f90 $(FFLAGS)rkqs.$(OBJ)	
rkck.$(OBJ)	: rkck.f90
	$(FOR) rkck.f90 $(FFLAGS)rkck.$(OBJ)	
odeint.$(OBJ)	: odeint.f90
	$(FOR) odeint.f90 $(FFLAGS)odeint.$(OBJ)	
zbrent.$(OBJ)	: zbrent.f90
	$(FOR) zbrent.f90 $(FFLAGS2)zbrent.$(OBJ)	
hygfx.$(OBJ) : hygfx.for 
	$(FOR) hygfx.for $(FFLAGS)hygfx.$(OBJ) 
random.$(OBJ) : random.f90 
	$(FOR) random.f90 $(FFLAGS)random.$(OBJ) 
variables.$(OBJ) : variables.f90
	$(FOR) variables.f90 $(FFLAGS)variables.$(OBJ)
mpi_module.$(OBJ) : mpi_module.f90
	$(FOR) mpi_module.f90 $(FFLAGS)mpi_module.$(OBJ)
initialisation.$(OBJ) : initialisation.f90 random.$(OBJ) mpi_module.$(OBJ)
	$(FOR) initialisation.f90 -I ${NETCDFMOD} \
			$(FFLAGS)initialisation.$(OBJ)
driver_code.$(OBJ) : driver_code.f90 advection.$(OBJ) mpi_module.$(OBJ)
	$(FOR) driver_code.f90  -I ${NETCDFMOD} \
			$(FFLAGS)driver_code.$(OBJ)
advection.$(OBJ) : advection.f90
	$(FOR) advection.f90  $(FFLAGS)advection.$(OBJ)
main.$(OBJ)   : main.f90 variables.$(OBJ) mpi_module.$(OBJ) initialisation.$(OBJ) \
				driver_code.$(OBJ) advection.$(OBJ)
	$(FOR)  main.f90 -I ${NETCDFMOD}  $(FFLAGS)main.$(OBJ) 

clean :
	rm *.exe  *.o *.mod *~ \
	model_lib.a

