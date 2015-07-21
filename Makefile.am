
vapidir = $(datadir)/vala/vapi
dist_vapi_DATA = vex.vapi
include_HEADERS = vex.h

lib_LTLIBRARIES = libvex.la

libvex_la_SOURCES = \
  src/component.vala \
  src/entity.vala \
  src/manager.vala

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
  --pkg config

ACLOCAL_AMFLAGS = -I m4
