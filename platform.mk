# if(PLAT == null)
# do
# PLAT = none
# else if(PLAT != null)
# return PLAT
PLAT ?= none

# PLATS="linux freebsd macosx"
PLATS = linux freebsd macosx

# if(CC == null)
# do
# CC = gcc
# else if(CC != null)
# do
# return CC
CC ?= gcc

# super none
# super $(PLATS)
# super clean
# super all
# super cleanall 
.PHONY : none $(PLATS) clean all cleanall

#ifneq ($(PLAT), none)
# super default
.PHONY : default

# make macosx
default :
	$(MAKE) $(PLAT)

#endif

none :
	@echo "Please do 'make PLATFORM' where PLATFORM is one of these:"
	@echo "   $(PLATS)"

SKYNET_LIBS := -lpthread -lm
SHARED := -fPIC --shared
EXPORT := -Wl,-E

linux : PLAT = linux
macosx : PLAT = macosx
freebsd : PLAT = freebsd

macosx : SHARED := -fPIC -dynamiclib -Wl,-undefined,dynamic_lookup
macosx : EXPORT :=
macosx linux : SKYNET_LIBS += -ldl
linux freebsd : SKYNET_LIBS += -lrt

# Turn off jemalloc and malloc hook on macosx

macosx : MALLOC_STATICLIB :=
macosx : SKYNET_DEFINES :=-DNOUSE_JEMALLOC

# ./skynet cservice/snlua.so cservice/logger.so cservice/gate.so cservice/harbor.so luaclib/skynet.so luaclib/client.so luaclib/bson.so luaclib/md5.so luaclib/sproto.so
# luaclib/lpeg.so PLAT=macosx SKYNET_LIBS="-lpthread -lm -ldl" SHARED="-fPIC -dynamiclib -Wl,-undefined,dynamic_lookup" EXPORT="" MALLOC_STATICLIB="" SKYNET_DEFINES=-"DNOUSE_JEMALLOC"
linux macosx freebsd :
	$(MAKE) all PLAT=$@ SKYNET_LIBS="$(SKYNET_LIBS)" SHARED="$(SHARED)" EXPORT="$(EXPORT)" MALLOC_STATICLIB="$(MALLOC_STATICLIB)" SKYNET_DEFINES="$(SKYNET_DEFINES)"
