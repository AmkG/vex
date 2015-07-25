
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
  test/t001 \
  test/t002 \
  test/t003 \
  test/t004 \
  test/t005
check_VALAFLAGS = \
  --vapidir=$(top_srcdir) \
  --pkg vex
check_CFLAGS = \
  $(GLIB2_CFLAGS)
check_LDADD = \
  libvex.la \
  $(GLIB2_LIBS) \
  $(GOBJECT2_LIBS)

TESTS = $(check_PROGRAMS)

test_t001_SOURCES   = test/001.vala
test_t001_VALAFLAGS = $(check_VALAFLAGS)
test_t001_CFLAGS    = $(check_CFLAGS)
test_t001_LDADD     = $(check_LDADD)

test_t002_SOURCES   = test/002.vala
test_t002_VALAFLAGS = $(check_VALAFLAGS)
test_t002_CFLAGS    = $(check_CFLAGS)
test_t002_LDADD     = $(check_LDADD)

test_t003_SOURCES   = test/003.vala
test_t003_VALAFLAGS = $(check_VALAFLAGS)
test_t003_CFLAGS    = $(check_CFLAGS)
test_t003_LDADD     = $(check_LDADD)

test_t004_SOURCES   = test/004.vala
test_t004_VALAFLAGS = $(check_VALAFLAGS)
test_t004_CFLAGS    = $(check_CFLAGS)
test_t004_LDADD     = $(check_LDADD)

test_t005_SOURCES   = test/005.vala
test_t005_VALAFLAGS = $(check_VALAFLAGS)
test_t005_CFLAGS    = $(check_CFLAGS)
test_t005_LDADD     = $(check_LDADD)

