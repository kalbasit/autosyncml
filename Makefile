VERSION=`git describe --always HEAD`

prefix=/usr/local
etcdir=/etc
bindir=$(prefix)/bin
libdir=$(prefix)/lib
autosyncmllibdir=$(libdir)/autosyncml
sharedir=$(prefix)/share
INSTALL=install
MAKE=make
GIT=git

all: targets;

update:
	$(GIT) pull --rebase

targets: make-bin-targets
	
	#make-lib-targets make-etc-targets;

make-bin-targets:
	@sed -e "s:\(VERSION=\).*:\1$(VERSION):g" bin/Makefile.in > bin/Makefile.tmp
	@mv bin/Makefile.tmp bin/Makefile
	$(MAKE) -C bin targets

make-lib-targets:
	@sed -e "s:\(VERSION=\).*:\1$(VERSION):g" lib/Makefile.in > lib/Makefile.tmp
	@mv lib/Makefile.tmp lib/Makefile
	$(MAKE) -C lib targets

make-etc-targets:
	@sed -e "s:\(VERSION=\).*:\1$(VERSION):g" etc/Makefile.in > etc/Makefile.tmp
	@mv etc/Makefile.tmp etc/Makefile
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

clean:
	sed -e "s:\(VERSION=\).*:\1$(VERSION):g" bin/Makefile.in > bin/Makefile
	$(MAKE) -C bin clean
	$(MAKE) -C lib clean
	$(MAKE) -C etc clean
	rm -f bin/Makefile
	rm -f etc/Makefile
	rm -f lib/Makefile
