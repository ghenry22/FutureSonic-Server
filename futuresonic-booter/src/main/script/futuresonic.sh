#!/bin/sh

###################################################################################
# Shell script for starting FutureSonic.  See http://futuresonic.org.
###################################################################################

MADSONIC_HOME=/var/futuresonic
MADSONIC_HOST=0.0.0.0
MADSONIC_PORT=4040
MADSONIC_HTTPS_PORT=0
MADSONIC_CONTEXT_PATH=/
MADSONIC_INIT_MEMORY=256
MADSONIC_MAX_MEMORY=350
MADSONIC_PIDFILE=
MADSONIC_DEFAULT_MUSIC_FOLDER=/var/media
MADSONIC_DEFAULT_UPLOAD_FOLDER=/var/media/Incoming
MADSONIC_DEFAULT_PODCAST_FOLDER=/var/media/Podcast
MADSONIC_DEFAULT_PLAYLIST_IMPORT_FOLDER=/var/media/playlist-import
MADSONIC_DEFAULT_PLAYLIST_EXPORT_FOLDER=/var/media/playlist-export

quiet=0

usage() {
    echo "Usage: futuresonic.sh [options]"
    echo "  --help               This small usage guide."
    echo "  --home=DIR           The directory where FutureSonic will create files."
    echo "                       Make sure it is writable. Default: /var/futuresonic"
    echo "  --host=HOST          The host name or IP address on which to bind FutureSonic."
    echo "                       Only relevant if you have multiple network interfaces and want"
    echo "                       to make FutureSonic available on only one of them. The default value"
    echo "                       will bind FutureSonic to all available network interfaces. Default: 0.0.0.0"
    echo "  --port=PORT          The port on which FutureSonic will listen for"
    echo "                       incoming HTTP traffic. Default: 4040"
    echo "  --https-port=PORT    The port on which FutureSonic will listen for"
    echo "                       incoming HTTPS traffic. Default: 0 (disabled)"
    echo "  --context-path=PATH  The context path, i.e., the last part of the FutureSonic"
    echo "                       URL. Typically '/' or '/futuresonic'. Default '/'"
    echo "  --init-memory=MB     The memory initial size (Init Java heap size) in megabytes."
    echo "                       Default: 256"
    echo "  --max-memory=MB      The memory limit (max Java heap size) in megabytes."
    echo "                       Default: 350"
    echo "  --pidfile=PIDFILE    Write PID to this file. Default not created."
    echo "  --quiet              Don't print anything to standard out. Default false."
    echo "  --default-music-folder=DIR           Configure FutureSonic to use this folder for music.  This option "
    echo "                                       only has effect the first time FutureSonic is started. Default '/var/media/artists'"
    echo "  --default-upload-folder=DIR          Configure FutureSonic to use this folder for music.  This option "
    echo "                                       only has effect the first time FutureSonic is started. Default '/var/media/Incoming'"
    echo "  --default-podcast-folder=DIR         Configure FutureSonic to use this folder for Podcasts.  This option "
    echo "                                       only has effect the first time FutureSonic is started. Default '/var/media/Podcast'"
    echo "  --default-playlist-import-folder=DIR Configure FutureSonic to use this folder for playlist import.  This option "
    echo "                                       only has effect the first time FutureSonic is started. Default '/var/media/playlist-import'"
    echo "  --default-playlist-export-folder=DIR Configure FutureSonic to use this folder for playlist export.  This option "
    echo "                                       only has effect the first time FutureSonic is started. Default '/var/media/playlist-export'"
    exit 1
}

# Parse arguments.
while [ $# -ge 1 ]; do
    case $1 in
        --help)
            usage
            ;;
        --home=?*)
            MADSONIC_HOME=${1#--home=}
            ;;
        --host=?*)
            MADSONIC_HOST=${1#--host=}
            ;;
        --port=?*)
            MADSONIC_PORT=${1#--port=}
            ;;
        --https-port=?*)
            MADSONIC_HTTPS_PORT=${1#--https-port=}
            ;;
        --context-path=?*)
            MADSONIC_CONTEXT_PATH=${1#--context-path=}
            ;;
        --init-memory=?*)
            MADSONIC_INIT_MEMORY=${1#--init-memory=}
            ;;
        --max-memory=?*)
            MADSONIC_MAX_MEMORY=${1#--max-memory=}
            ;;
        --pidfile=?*)
            MADSONIC_PIDFILE=${1#--pidfile=}
            ;;
        --quiet)
            quiet=1
            ;;
        --default-music-folder=?*)
            MADSONIC_DEFAULT_MUSIC_FOLDER=${1#--default-music-folder=}
            ;;
        --default-upload-folder=?*)
            MADSONIC_DEFAULT_UPLOAD_FOLDER=${1#--default-upload-folder=}
            ;;
        --default-podcast-folder=?*)
            MADSONIC_DEFAULT_PODCAST_FOLDER=${1#--default-podcast-folder=}
            ;;
        --default-playlist-folder=?*)
            MADSONIC_DEFAULT_PLAYLIST_IMPORT_FOLDER=${1#--default-playlist-import-folder=}
            ;;
        --default-playlist-export-folder=?*)
            MADSONIC_DEFAULT_PLAYLIST_EXPORT_FOLDER=${1#--default-playlist-export-folder=}
            ;;
        *)
            usage
            ;;
    esac
    shift
done

# Use JAVA_HOME if set, otherwise assume java is in the path.
JAVA=java
if [ -e "${JAVA_HOME}" ]
    then
    JAVA=${JAVA_HOME}/bin/java
fi

# Create FutureSonic home directory.
mkdir -p ${MADSONIC_HOME}
LOG=${MADSONIC_HOME}/futuresonic_sh.log
rm -f ${LOG}

cd $(dirname $0)
if [ -L $0 ] && ([ -e /bin/readlink ] || [ -e /usr/bin/readlink ]); then
    cd $(dirname $(readlink $0))
fi

${JAVA} -Xms${MADSONIC_INIT_MEMORY}m -Xmx${MADSONIC_MAX_MEMORY}m \
  -Dsubsonic.home=${MADSONIC_HOME} \
  -Dsubsonic.host=${MADSONIC_HOST} \
  -Dsubsonic.port=${MADSONIC_PORT} \
  -Dsubsonic.httpsPort=${MADSONIC_HTTPS_PORT} \
  -Dsubsonic.contextPath=${MADSONIC_CONTEXT_PATH} \
  -Dsubsonic.defaultMusicFolder=${MADSONIC_DEFAULT_MUSIC_FOLDER} \
  -Dsubsonic.defaultUploadFolder=${MADSONIC_DEFAULT_UPLOAD_FOLDER} \
  -Dsubsonic.defaultPodcastFolder=${MADSONIC_DEFAULT_PODCAST_FOLDER} \
  -Dsubsonic.defaultPlaylistFolder=${MADSONIC_DEFAULT_PLAYLIST_IMPORT_FOLDER} \
  -Dsubsonic.defaultPlaylistExportFolder=${MADSONIC_DEFAULT_PLAYLIST_EXPORT_FOLDER} \
  -Djava.awt.headless=true \
  -verbose:gc \
  -jar futuresonic-booter.jar > ${LOG} 2>&1 &

# Write pid to pidfile if it is defined.
if [ $MADSONIC_PIDFILE ]; then
    echo $! > ${MADSONIC_PIDFILE}
fi

if [ $quiet = 0 ]; then
    echo Started FutureSonic [PID $!, ${LOG}]
fi

