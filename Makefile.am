
vapidir = $(datadir)/vala/vapi
dist_vapi_DATA = vex.vapi
include_HEADERS = vex.h

pkgconfigdir = $(libdir)/pkgconfig
nodist_pkgconfig_DATA = vex.pc
vex.pc : $(srcdir)/vex.pc.in
	sed -e 's![@]prefix[@]!$(prefix)!g' \
	    -e 's![@]exec_prefix[@]!$(exec_prefix)!g' \
	    -e 's![@]includedir[@]!$(includedir)!g' \
	    -e 's![@]libdir[@]!$(libdir)!g' \
	    -e 's![@]PACKAGE_VERSION[@]!$(PACKAGE_VERSION)!g' \
	    $< > $@

lib_LTLIBRARIES = libvex.la

libvex_la_SOURCES = \
  src/component.vala \
  src/component_col.vala \
  src/component_col_base.vala \
  src/component_col_iterator.vala \
  src/entity.vala \
  src/manager.vala \
  src/seq_point.vala \
  src/subsystem.vala \
  src/subsystem_par.vala \
  src/subsystem_runner.vala \
  src/subsystem_seq.vala \
  src/system.vala \
  src/system_factory.vala \
  src/thread_pool.vala

libvex_la_CFLAGS = \
  $(GEE_CFLAGS) \
  $(GLIB2_CFLAGS) \
  $(GOBJECT2_CFLAGS)

libvex_la_LIBADD = \
  $(GEE_LIBS) \
  $(GLIB2_LIBS) \
  $(GOBJECT2_LIBS)

libvex_la_VALAFLAGS = \
  $(GEE_VALAFLAGS) \
  $(GLIB2_VALAFLAGS) \
  $(GOBJECT_VALAFLAGS) \
  --library vex -H vex.h \
  --vapi vex.vapi \
  --vapidir=$(top_srcdir) \
  --pkg config \
  --target-glib=2.32

ACLOCAL_AMFLAGS = -I m4

###############################################################################

SUBDIRS = . test
