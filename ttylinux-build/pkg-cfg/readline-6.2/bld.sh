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

PKG_URL="http://ftp.gnu.org/gnu/readline/"
PKG_TAR="readline-6.2.tar.gz"
PKG_SUM=""

PKG_NAME="readline"
PKG_VERSION="6.2"


# ******************************************************************************
# pkg_patch
# ******************************************************************************

pkg_patch() {

PKG_STATUS=""

cd "${PKG_NAME}-${PKG_VERSION}"
sed -e '/MV.*old/d'  -i Makefile.in
sed -e '/OLDSUFF/c:' -i support/shlib-install
cd ..

return 0

}


# ******************************************************************************
# pkg_configure
# ******************************************************************************

pkg_configure() {

PKG_STATUS="./configure error"

cd "${PKG_NAME}-${PKG_VERSION}"
source "${TTYLINUX_XTOOL_DIR}/_xbt_env_set"
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
	--libdir=/lib || return 1
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
	CROSS_COMPILE=${XBT_TARGET}- \
	SHLIB_LIBS=-lncurses || return 1
source "${TTYLINUX_XTOOL_DIR}/_xbt_env_clr"
cd ..

PKG_STATUS=""
return 0

}


# ******************************************************************************
# pkg_install
# ******************************************************************************

pkg_install() {

PKG_STATUS="Unspecified error -- check the ${PKG_NAME} build log"

cd "${PKG_NAME}-${PKG_VERSION}"

source "${TTYLINUX_XTOOL_DIR}/_xbt_env_set"
PATH="${XBT_BIN_PATH}:${PATH}" make \
	CROSS_COMPILE=${XBT_TARGET}- \
	DESTDIR=${TTYLINUX_SYSROOT_DIR} \
	install || return 1
source "${TTYLINUX_XTOOL_DIR}/_xbt_env_clr"

# Put static libraries into /usr/lib and give them the correct permissions.
#
mv ${TTYLINUX_SYSROOT_DIR}/lib/libhistory.a  ${TTYLINUX_SYSROOT_DIR}/usr/lib/
mv ${TTYLINUX_SYSROOT_DIR}/lib/libreadline.a ${TTYLINUX_SYSROOT_DIR}/usr/lib/

# Give the shared libraries the correct permissions and make links to them
# in /usr/lib.
#
chmod 755 ${TTYLINUX_SYSROOT_DIR}/lib/libhistory.so.6.2
chmod 755 ${TTYLINUX_SYSROOT_DIR}/lib/libreadline.so.6.2
rm -f ${TTYLINUX_SYSROOT_DIR}/usr/lib/libhistory.so
rm -f ${TTYLINUX_SYSROOT_DIR}/usr/lib/libreadline.so
ln -fs ../../lib/libhistory.so.6  ${TTYLINUX_SYSROOT_DIR}/usr/lib/libhistory.so
ln -fs ../../lib/libreadline.so.6 ${TTYLINUX_SYSROOT_DIR}/usr/lib/libreadline.so

cd ..

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
