Name:           futuresonic
Version:        @VERSION@
Release:        @BUILD_NUMBER@
Summary:        A web-based music streamer, jukebox and Podcast receiver

Group:          Applications/Multimedia
License:        GPLv3
URL:            http://futuresonic.org

%description
FutureSonic is a web-based music streamer, jukebox and Podcast receiver,
providing access to your music collection wherever you are. Use it
to share your music with friends, or to listen to your music while away
from home.

Apps for Android, iPhone and Windows Phone are also available.

Java 1.6 or higher is required to run Subsonic.

FutureSonic can be found at http://futuresonic.org

%files
%defattr(644,root,root,755)
/usr/share/futuresonic/futuresonic-booter.jar
/usr/share/futuresonic/futuresonic.war
%attr(755,root,root) /usr/share/futuresonic/futuresonic.sh
%attr(755,root,root) /etc/init.d/futuresonic
%attr(755,root,root) /var/futuresonic/transcode/Audioffmpeg
%attr(755,root,root) /var/futuresonic/transcode/ffmpeg
%attr(755,root,root) /var/futuresonic/transcode/lame
%attr(755,root,root) /var/futuresonic/transcode/xmp
%config(noreplace) /etc/sysconfig/futuresonic

%pre
# Stop Subsonic service.
if [ -e /etc/init.d/futuresonic ]; then
  service futuresonic stop
fi

# Backup database.
if [ -e /var/futuresonic/db ]; then
  rm -rf /var/futuresonic/db.backup
  cp -R /var/futuresonic/db /var/futuresonic/db.backup
fi

exit 0

%post
ln -sf /usr/share/futuresonic/futuresonic.sh /usr/bin/futuresonic
chmod 750 /var/futuresonic

# Clear jetty cache.
rm -rf /var/futuresonic/jetty

# For SELinux: Set security context
chcon -t java_exec_t /etc/init.d/futuresonic 2>/dev/null

# Configure and start Subsonic service.
chkconfig --add futuresonic
service futuresonic start

exit 0

%preun
# Only do it if uninstalling, not upgrading.
if [ $1 = 0 ] ; then

  # Stop the service.
  [ -e /etc/init.d/futuresonic ] && service futuresonic stop

  # Remove symlink.
  rm -f /usr/bin/futuresonic

  # Remove startup scripts.
  chkconfig --del futuresonic

fi

exit 0

