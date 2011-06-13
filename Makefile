# Makefile for Ssfs
#
PREFIX?=/usr
DOCDIR?=$(PREFIX)/share/doc
DESTDIR?=

PACKAGE=ssfs
VERSION=0.1-beta
LINGUAS?=fr

all: msgmerge

# i18n

pot:
	xgettext -o po/ssfs.pot -L Shell \
		--package-name="Ssfs" \
		--package-version="$(VERSION)" \
		./ssfs ./ssfs-box

msgmerge:
	@for l in $(LINGUAS); do \
		echo -n "Updating $$l po file."; \
		msgmerge -U po/$$l.po po/ssfs.pot; \
	done;

msgfmt:
	@for l in $(LINGUAS); do \
		echo "Compiling $$l mo file..."; \
		mkdir -p po/mo/$$l/LC_MESSAGES; \
		msgfmt -o po/mo/$$l/LC_MESSAGES/ssfs.mo po/$$l.po; \
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
