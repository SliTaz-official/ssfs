#!/bin/sh
#
echo "Content-Type: text/html"
echo ""

. /etc/ssfs/ssfs-server.conf

notes=/var/cache/ssfs/notes
root=$SSFS_CHROOT
vdisk=$(basename $SSFS_VDISK)
vsize=$(du -sh $SSFS_VDISK | awk '{print $1}')
vused=$(du -sh $root | awk '{print $1}')
users=$(ls $root/home | wc -l)
pct=$(df $root | fgrep $root | awk '{print $5}')
tz=$(cat /etc/TZ)
date=$(date "+%Y-%m-%d %H:%M")

# XHTML footer function.
xhtml_footer() {
	cat << EOT
</div>

<div id="footer">
	Ssfs Open Source - <a href="$SCRIPT_NAME?doc">Documentation</a>
	- <a href="http://scn.slitaz.org/groups/ssfs/">Community</a>
</div>

</body>
</html>
EOT
}

# xHTML 5 header.
cat << EOT
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>Ssfs Server</title>
	<meta charset="utf-8" />
	<link rel="shortcut icon" href="favicon.ico" />
	<link rel="stylesheet" type="text/css" href="style.css" />
</head>
<body>

EOT

case ${QUERY_STRING} in
	doc)
		# Open a doc for content but keep small margins.
		echo '<div>'
		#echo '<h1>Ssfs Documentation</h1>'
		echo '<pre>'
		cat /usr/share/doc/ssfs/README | sed \
			-e s"#^[\#|\$]\([^']*\)#<span style='color: brown;'>\0</span>#"g \
			-e s"#http://\([^']*\).*#<a href='\0'>\0</a>#"g
		echo '</pre>'
		xhtml_footer && exit 0 ;;
esac

# Content
cat << EOT
<!-- <h1>Ssfs Server</h1> -->

<div id="content">

<h2>Ssfs server $(hostname)</h2>
<pre>
Server time   : $date
Time zone     : $tz
</pre>

<h2>Virtual disk stats</h2>
<pre>
Virtual disk  : $vdisk
Ssfs root     : $root
Vdisk size    : $vsize
Vdisk usage   : $vused
Vdisk users   : $users
</pre>

<div class="box" style="padding: 0;">
	<div style="background: #d66018; width: $pct;">$pct</div>
</div>
<p>
	Filesystem usage provided by 'df' includes ext3 reserved space.
</p>

EOT

# Server admin notes for users.
if [ -f "$notes" ]; then
	echo '<h2>Server side notes</h2>'
	echo '<pre>'
	cat $notes | sed s"#http://\([^']*\).*#<a href='\0'>\0</a>#"g
	echo '</pre>'
fi

xhtml_footer
exit 0
