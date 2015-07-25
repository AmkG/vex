
vapidir = $(datadir)/vala/vapi
dist_vapi_DATA = vex.vapi
include_HEADERS = vex.h

lib_LTLIBRARIES = libvex.la

libvex_la_SOURCES = \
  src/component.vala \
  src/component_col.vala \
  src/component_col_base.vala \
  src/component_col_iterator.vala \
  src/entity.vala \
  src/manager.vala \
  src/subsystem.vala \
  src/subsystem_par.vala \
  src/subsystem_runner.vala \
  src/subsystem_seq.vala \
  src/system.vala \
  src/system_factory.vala

libvex_la_CFLAGS = \
  $(GEE_CFLAGS) \
  $(GLIB2_CFLAGS) \
  $(GOBJECT2_CFLAGS)

libvex_la_LIBADD = \
  $(GEE_LIBS) \
  $(GLIB2_LIBS) \
  $(GOBJECT2_LIBS)

libvex_la_VALAFLAGS = \
  --pkg gee-1.0 \
  --library vex -H vex.h \
  --vapi vex.vapi \
  --vapidir=$(top_srcdir) \
  --pkg config \
  --target-glib=2.32

ACLOCAL_AMFLAGS = -I m4

###############################################################################

check_PROGRAMS = \
  test/t001
check_VALAFLAGS = \
  --vapidir=$(top_srcdir) \
  --pkg vex
check_CFLAGS = \
  $(GLIB2_CFLAGS)
check_LDADD = \
  libvex.la \
  $(GLIB2_LIBS)

TESTS = $(check_PROGRAMS)

test_t001_SOURCES   = test/001.vala
test_t001_VALAFLAGS = $(check_VALAFLAGS)
test_t001_CFLAGS    = $(check_CFLAGS)
test_t001_LDADD     = $(check_LDADD)

