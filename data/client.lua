-- Configuration file for SliTaz Secure Filesystem lsyncd daemon.

sync {
	default.rsyncssh,
	source    = "/home/user/Sync",
	host      = "login@host",
	targetdir = "Sync/"
}
