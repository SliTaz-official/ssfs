# Makefile for Ssfs
#
PREFIX?=/usr
DOCDIR?=$(PREFIX)/share/doc
DESTDIR?=

PACKAGE=ssfs
VERSION=1.0
LINGUAS?=

all: msgmerge

# i18n

pot:
	xgettext -o po/ssfs/ssfs.pot -L Shell \
		--package-name="Ssfs Client" \
		--package-version="$(VERSION)" \
		./ssfs ./ssfs-box
	xgettext -o po/server/ssfs-server.pot -L Shell \
		--package-name="Ssfs Client" \
		--package-version="$(VERSION)" \
		./ssfs-server

msgmerge:
	@for l in $(LINGUAS); do \
		echo -n "Updating $$l po file."; \
		msgmerge -U po/$$l.po po/ssfs/ssfs.pot; \
	done;

msgfmt:
	@for l in $(LINGUAS); do \
		echo "Compiling $$l mo file..."; \
		mkdir -p po/mo/$$l/LC_MESSAGES; \
		msgfmt -o po/mo/$$l/LC_MESSAGES/ssfs.mo po/ssfs/$$l.po; \
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
	#cp -a po/mo/* $(DESTDIR)$(PREFIX)/share/locale
	touch $(DESTDIR)/var/lib/$(PACKAGE)/vdisk.files
