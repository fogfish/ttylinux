#!/bin/bash


# This file is part of the ttylinux software.
# The license which this software falls under is GPLv2 as follows:
#
# Copyright (C) 2010-2012 Douglas Jerome <douglas@ttylinux.org>
#
# This program is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the Free
# Software Foundation; either version 2 of the License, or (at your option)
# any later version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
# FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
# more details.
#
# You should have received a copy of the GNU General Public License along with
# this program; if not, write to the Free Software Foundation, Inc., 59 Temple
# Place, Suite 330, Boston, MA  02111-1307  USA


# ******************************************************************************
# Definitions
# ******************************************************************************

PKG_URL="http://ftp.gnu.org/gnu/ncurses/"
PKG_TAR="ncurses-5.9.tar.gz"
PKG_SUM=""

PKG_NAME="ncurses"
PKG_VERSION="5.9"


# ******************************************************************************
# pkg_patch
# ******************************************************************************

pkg_patch() {
PKG_STATUS=""
return 0
}


# ******************************************************************************
# pkg_configure
# ******************************************************************************

pkg_configure() {

local WITHOUT_CXX=""

PKG_STATUS="./configure error"

cd "${PKG_NAME}-${PKG_VERSION}"

mv misc/terminfo.src misc/terminfo.src-ORIG
cp ${TTYLINUX_PKGCFG_DIR}/${PKG_NAME}-${PKG_VERSION}/terminfo.src \
	misc/terminfo.src

source "${TTYLINUX_XTOOL_DIR}/_xbt_env_set"
if [[ x"${XBT_C_PLUS_PLUS}" == x"no" ]]; then
	WITHOUT_CXX="--without-cxx --without-cxx-bindings"
fi
AR="${XBT_AR}" \
AS="${XBT_AS} --sysroot=${TTYLINUX_SYSROOT_DIR}" \
CC="${XBT_CC} --sysroot=${TTYLINUX_SYSROOT_DIR}" \
CXX="${XBT_CXX} --sysroot=${TTYLINUX_SYSROOT_DIR}" \
LD="${XBT_LD} --sysroot=${TTYLINUX_SYSROOT_DIR}" \
NM="${XBT_NM}" \
OBJCOPY="${XBT_OBJCOPY}" \
RANLIB="${XBT_RANLIB}" \
SIZE="${XBT_SIZE}" \
STRIP="${XBT_STRIP}" \
CFLAGS="${TTYLINUX_CFLAGS}" \
./configure \
	--build=${MACHTYPE} \
	--host=${XBT_TARGET} \
	--prefix=/usr \
	--libdir=/lib \
	--mandir=/usr/share/man \
	--enable-shared \
	--enable-overwrite \
	--disable-largefile \
	--disable-termcap \
	--with-build-cc=gcc \
	--with-install-prefix=${TTYLINUX_SYSROOT_DIR} \
	--with-shared \
	--without-ada \
	${WITHOUT_CXX} \
	--without-debug \
	--without-gpm \
	--without-normal || return 1
source "${TTYLINUX_XTOOL_DIR}/_xbt_env_clr"

cd ..

PKG_STATUS=""
return 0

}


# ******************************************************************************
# pkg_make
# ******************************************************************************

pkg_make() {

PKG_STATUS="make error"

cd "${PKG_NAME}-${PKG_VERSION}"
source "${TTYLINUX_XTOOL_DIR}/_xbt_env_set"
PATH="${XBT_BIN_PATH}:${PATH}" make \
	--jobs=${NJOBS} \
	CROSS_COMPILE=${XBT_TARGET}- || return 1
source "${TTYLINUX_XTOOL_DIR}/_xbt_env_clr"
cd ..

PKG_STATUS=""
return 0

}


# ******************************************************************************
# pkg_install
# ******************************************************************************

pkg_install() {

PKG_STATUS="install error"

cd "${PKG_NAME}-${PKG_VERSION}"
source "${TTYLINUX_XTOOL_DIR}/_xbt_env_set"

PATH="${XBT_BIN_PATH}:${PATH}" make install || return 1

mv ${TTYLINUX_SYSROOT_DIR}/lib/libncurses++.a ${TTYLINUX_SYSROOT_DIR}/usr/lib/

_ln="ln --force --symbolic"
_usrlib="${TTYLINUX_SYSROOT_DIR}/usr/lib"
${_ln} ../../lib/libncurses.so.5   ${_usrlib}/libcurses.so
${_ln} ../../lib/libform.so.5      ${_usrlib}/libform.so
${_ln} ../../lib/libmenu.so.5      ${_usrlib}/libmenu.so
${_ln} ../../lib/libncurses.so.5   ${_usrlib}/libncurses.so
${_ln} ../../lib/libpanel.so.5     ${_usrlib}/libpanel.so
${_ln} ../../lib/libncurses.so.5.9 ${_usrlib}/libcurses.so.5
${_ln} ../../lib/libform.so.5.9    ${_usrlib}/libform.so.5
${_ln} ../../lib/libmenu.so.5.9    ${_usrlib}/libmenu.so.5
${_ln} ../../lib/libncurses.so.5.9 ${_usrlib}/libncurses.so.5
${_ln} ../../lib/libpanel.so.5.9   ${_usrlib}/libpanel.so.5
${_ln} libncurses.so.5 ${_usrlib}/libtinfo.so.5
${_ln} libtinfo.so.5   ${_usrlib}/libtinfo.so
unset _ln

source "${TTYLINUX_XTOOL_DIR}/_xbt_env_clr"
cd ..

echo "Copying ${PKG_NAME} ttylinux-specific components to build-root."
if [[ -d "rootfs/" ]]; then
	find "rootfs/" ! -type d -exec touch {} \;
	cp --archive --force rootfs/* "${TTYLINUX_SYSROOT_DIR}"
fi

PKG_STATUS=""
return 0

}


# ******************************************************************************
# pkg_clean
# ******************************************************************************

pkg_clean() {
PKG_STATUS=""
return 0
}


# end of file
