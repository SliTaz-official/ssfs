# Makefile for Ssfs
#
PREFIX?=/usr
DOCDIR?=$(PREFIX)/share/doc
DESTDIR?=

PACKAGE=ssfs
VERSION=1.0
PROJECTS=ssfs-server ssfs
LINGUAS=el fr pt_BR ru zh_CN zh_TW

all: msgfmt

# i18n

pot:
	xgettext -o po/ssfs/ssfs.pot -L Shell \
		--package-name="Ssfs Client" \
		--package-version="$(VERSION)" \
		./ssfs ./ssfs-box
	xgettext -o po/ssfs-server/ssfs-server.pot -L Shell \
		--package-name="Ssfs Server" \
		--package-version="$(VERSION)" \
		./ssfs-server

msgmerge:
	@for p in $(PROJECTS); do \
		for l in $(LINGUAS); do \
			if [ -f "po/$$p/$$l.po" ]; then \
				echo -n "Updating $$p $$l po file."; \
				msgmerge -U po/$$p/$$l.po po/$$p/$$p.pot; \
			fi; \
		done; \
	done;

msgfmt:
	@for p in $(PROJECTS); do \
		for l in $(LINGUAS); do \
			if [ -f "po/$$p/$$l.po" ]; then \
				echo -e "Compiling $$p $$l mo file...\n"; \
				mkdir -p po/mo/$$l; \
				msgfmt -o po/mo/$$l/$$p.mo po/$$p/$$l.po; \
			fi; \
		done; \
	done;

# Installation

install:
	mkdir -p $(DESTDIR)/bin \
		$(DESTDIR)/etc/$(PACKAGE) \
		$(DESTDIR)$(DOCDIR)/$(PACKAGE) \
		$(DESTDIR)$(PREFIX)/bin \
		$(DESTDIR)$(PREFIX)/sbin \
		$(DESTDIR)/var/lib/$(PACKAGE) \
		$(DESTDIR)$(PREFIX)/share/applications \
		$(DESTDIR)$(PREFIX)/share/pixmaps \
		$(DESTDIR)$(PREFIX)/share/locale \
		$(DESTDIR)$(PREFIX)/share/$(PACKAGE)/rootfs/bin
	install -m 0755 $(PACKAGE)-sh $(DESTDIR)/bin
	install -m 0755 $(PACKAGE) $(DESTDIR)$(PREFIX)/bin
	install -m 0755 $(PACKAGE)-box $(DESTDIR)$(PREFIX)/bin
	install -m 0755 $(PACKAGE)-server $(DESTDIR)$(PREFIX)/sbin
	install -m 0644 README $(DESTDIR)$(DOCDIR)/$(PACKAGE)
	install -m 0644 data/$(PACKAGE)-server.conf $(DESTDIR)/etc/$(PACKAGE)
	install -m 0644 data/$(PACKAGE).png $(DESTDIR)$(PREFIX)/share/pixmaps
	install -m 0644 data/$(PACKAGE).desktop \
		$(DESTDIR)$(PREFIX)/share/applications
	install -m 0755 $(PACKAGE)-env \
		$(DESTDIR)$(PREFIX)/share/$(PACKAGE)/rootfs/bin
	cp -a po/mo/* $(DESTDIR)$(PREFIX)/share/locale
	touch $(DESTDIR)/var/lib/$(PACKAGE)/vdisk.files

clean:
	rm -rf po/mo
	rm -f po/*/*~

help:
	@echo ""
	@echo "make: pot msgmerge msgfmt install clean"
	@echo ""
