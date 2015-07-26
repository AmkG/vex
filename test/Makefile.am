
check_PROGRAMS = \
  t001 \
  t002 \
  t003 \
  t004 \
  t005

AM_VALAFLAGS = \
  --vapidir=$(top_srcdir) \
  --pkg vex
AM_CFLAGS = \
  $(GLIB2_CFLAGS)
LDADD = \
  $(top_builddir)/libvex.la \
  $(GLIB2_LIBS) \
  $(GOBJECT2_LIBS)

TESTS = $(check_PROGRAMS)

t001_SOURCES = 001.vala
t002_SOURCES = 002.vala
t003_SOURCES = 003.vala
t004_SOURCES = 004.vala
t005_SOURCES = 005.vala
