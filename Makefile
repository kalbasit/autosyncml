#
#   Copyright (c) 2010 Wael Nasreddine <wael.nasreddine@gmail.com>
#
#   This program is free software; you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation; either version 2 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program; if not, write to the Free Software
#   Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307,
#   USA.
#

VERSION=`git describe --always HEAD`

prefix=/usr/local
etcdir=$(prefix)/etc
bindir=$(prefix)/bin
libdir=$(prefix)/lib
autosyncmllibdir=$(libdir)/autosyncml
sharedir=$(prefix)/share
INSTALL=install
MAKE=make
GIT=git
ECHO=echo

all: prepare-makefiles targets;

update:
	@$(GIT) pull --rebase

targets: make-bin-targets make-lib-targets make-etc-targets;

prepare-makefiles: prepare-bin-makefile prepare-etc-makefile prepare-lib-makefile;

prepare-bin-makefile:
	@sed -e "s:\(VERSION=\).*:\1$(VERSION):g" bin/Makefile.in > bin/Makefile.tmp
	@mv bin/Makefile.tmp bin/Makefile

prepare-etc-makefile:
	@sed -e "s:\(VERSION=\).*:\1$(VERSION):g" lib/Makefile.in > lib/Makefile.tmp
	@mv lib/Makefile.tmp lib/Makefile

prepare-lib-makefile:
	@sed -e "s:\(VERSION=\).*:\1$(VERSION):g" etc/Makefile.in > etc/Makefile.tmp
	@mv etc/Makefile.tmp etc/Makefile

make-bin-targets:
	$(MAKE) -C bin targets

make-lib-targets:
	$(MAKE) -C lib targets

make-etc-targets:
	$(MAKE) -C etc targets

install:
	$(INSTALL) -d -m 755 $(DESTDIR)$(bindir)
	$(INSTALL) -d -m 755 $(DESTDIR)$(libdir)
	$(INSTALL) -d -m 755 $(DESTDIR)$(etcdir)
	$(INSTALL) -d -m 755 $(DESTDIR)$(sharedir)
	$(INSTALL) -d -m 755 $(DESTDIR)$(autosyncmllibdir)
	$(MAKE) -C bin install
	$(MAKE) -C lib install
	$(MAKE) -C etc install

clean: prepare-makefiles
	$(MAKE) -C bin clean
	$(MAKE) -C lib clean
	$(MAKE) -C etc clean
	rm -f bin/Makefile
	rm -f etc/Makefile
	rm -f lib/Makefile

help:
	@$(ECHO) -e \
		"To install autosyncml, first run make and then run make install\n" \
		"autosyncml installs by default on /usr/local, it can be changed using prefix=, i.e make prefix=/usr\n" \
		"If you plan to package it, you can use DESTDIR to install files to a special directory and keep the prefix intact.\n"
