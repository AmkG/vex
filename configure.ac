#                                               -*- Autoconf -*-
# Process this file with autoconf to produce a configure script.

AC_PREREQ([2.69])
AC_INIT([VEX], [0.1A], [almkglor@gmail.com])
AC_CONFIG_AUX_DIR([auxdir])
AC_CONFIG_MACRO_DIR([m4])
AM_INIT_AUTOMAKE([subdir-objects])
LT_INIT

# Checks for programs.
AC_PROG_CC
AM_PROG_CC_C_O
AM_PROG_VALAC

# Checks for libraries.
PKG_CHECK_MODULES([GLIB2], [glib-2.0],,[
  AC_MSG_ERROR([GLIB2 not found.])
])
PKG_CHECK_MODULES([GOBJECT2], [gobject-2.0],,[
  AC_MSG_ERROR([GOBJECT2 not found.])
])
PKG_CHECK_MODULES([GEE], [gee-1.0],,[
  AC_MSG_ERROR([GEE not found.])
])

# Checks for header files.

# Checks for typedefs, structures, and compiler characteristics.

# Checks for library functions.

AC_CONFIG_HEADERS([config.h])
AC_CONFIG_FILES([Makefile])
AC_OUTPUT
