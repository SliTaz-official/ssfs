# Makefile for Ssfs
#
PREFIX?=/usr
DOCDIR?=$(PREFIX)/share/doc
DESTDIR?=

PACKAGE=ssfs
VERSION=0.1-beta

all:

install:
	mkdir -p $(DESTDIR)/bin \
		$(DESTDIR)/etc/$(PACKAGE) \
		$(DESTDIR)$(DOCDIR)/$(PACKAGE) \
		$(DESTDIR)$(PREFIX)/bin \
		$(DESTDIR)$(PREFIX)/sbin \
		$(DESTDIR)/var/lib/$(PACKAGE) \
		$(DESTDIR)$(PREFIX)/share/applications \
		$(DESTDIR)$(PREFIX)/share/pixmaps
	install -m 0755 $(PACKAGE)-sh $(DESTDIR)/bin
	install -m 0755 $(PACKAGE) $(DESTDIR)$(PREFIX)/bin
	install -m 0755 $(PACKAGE)-box $(DESTDIR)$(PREFIX)/bin
	install -m 0755 $(PACKAGE)-server $(DESTDIR)$(PREFIX)/sbin
	install -m 0644 README $(DESTDIR)$(DOCDIR)/$(PACKAGE)
	install -m 0644 data/$(PACKAGE)-server.conf $(DESTDIR)/etc/$(PACKAGE)
	install -m 0644 data/$(PACKAGE).png $(DESTDIR)$(PREFIX)/share/pixmaps
	install -m 0644 data/$(PACKAGE).desktop \
		$(DESTDIR)$(PREFIX)/share/applications
	touch $(DESTDIR)/var/lib/$(PACKAGE)/vdisk.files
