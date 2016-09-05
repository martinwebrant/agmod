#
# Half-Life StandardSDK 2.2 mp_i386.so Makefile for i386 Linux
#
# October 2001 by Leon Hartwig (hartwig@valvesoftware.com)
#

DLLNAME=mm_say

ARCH=i386

#make sure this is the correct compiler for your system
CC=gcc

DLL_SRCDIR=.
ENGINE_SRCDIR=../engine
COMMON_SRCDIR=../common
WPN_SHARED_SRCDIR=./wpn_shared
PM_SHARED_SRCDIR=../pm_shared
GAME_SHARED_SRCDIR=../game_shared
MINISTL_SRCDIR=../metamod
DLLS_SRCDIR=../dlls

DLL_OBJDIR=$(DLL_SRCDIR)/obj
WPN_SHARED_OBJDIR=$(WPN_SHARED_SRCDIR)/obj
PM_SHARED_OBJDIR=$(PM_SHARED_SRCDIR)/obj
GAME_SHARED_OBJDIR=$(GAME_SHARED_SRCDIR)/obj

BASE_CFLAGS=	-Dstricmp=strcasecmp -D_strnicmp=strncasecmp -Dstrnicmp=strncasecmp \
		-DCLIENT_WEAPONS

#safe optimization
CFLAGS=$(BASE_CFLAGS) -w -m486 -O1

#full optimization
#CFLAGS=$(BASE_CFLAGS) -w -O1 -m486 -ffast-math -funroll-loops \
	-fomit-frame-pointer -fexpensive-optimizations \
	-malign-loops=2 -malign-jumps=2 -malign-functions=2

#use these when debugging 
#CFLAGS=$(BASE_CFLAGS) -g

INCLUDEDIRS=-I. -I$(ENGINE_SRCDIR) -I$(COMMON_SRCDIR) -I$(PM_SHARED_SRCDIR) -I$(GAME_SHARED_SRCDIR) -I$(MINISTL_SRCDIR) -I$(DLLS_SRCDIR)

LDFLAGS=-lm

SHLIBEXT=so
SHLIBCFLAGS=-fPIC
SHLIBLDFLAGS=-shared

DO_CC=$(CC) $(CFLAGS) $(SHLIBCFLAGS) $(INCLUDEDIRS) -o $@ -c $<

#############################################################################
# SETUP AND BUILD
# GAME
#############################################################################

$(DLL_OBJDIR)/%.o: $(DLL_SRCDIR)/%.cpp
	$(DO_CC)

$(WPN_SHARED_OBJDIR)/%.o: $(WPN_SHARED_SRCDIR)/%.cpp
	$(DO_CC)

$(GAME_SHARED_OBJDIR)/%.o: $(GAME_SHARED_SRCDIR)/%.cpp
	$(DO_CC)

$(PM_SHARED_OBJDIR)/%.o: $(PM_SHARED_SRCDIR)/%.c
	$(DO_CC)

OBJ = \
	$(DLL_OBJDIR)/dllapi.o \
	$(DLL_OBJDIR)/h_export.o \
	$(DLL_OBJDIR)/meta_api.o \
	$(DLL_OBJDIR)/sdk_util.o \

$(DLLNAME)_$(ARCH).$(SHLIBEXT) : neat $(OBJ)
	$(CC) $(CFLAGS) $(SHLIBLDFLAGS) $(LDFLAGS) -o $@ $(OBJ)

neat:
	-mkdir $(DLL_OBJDIR)
	-mkdir $(WPN_SHARED_OBJDIR)
	-mkdir $(GAME_SHARED_OBJDIR)
	-mkdir $(PM_SHARED_OBJDIR)
clean:
	-rm -f $(OBJ)
	-rm -f $(DLLNAME)_$(ARCH).$(SHLIBEXT)
spotless: clean
	-rm -r $(DLL_OBJDIR)
	-rm -r $(WPN_SHARED_OBJDIR)
	-rm -r $(GAME_SHARED_OBJDIR)
	-rm -r $(PM_SHARED_OBJDIR)

