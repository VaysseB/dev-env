main() {
    local DRY_RUN=0
    local HELP=0
    
    while [[ $# -gt 0 ]]
    do
        case "$1" in
            "--dry-run") DRY_RUN=1;;
            "-h"|"--help") HELP=1;;
            *) echo "Unknwon parameter '$1'"; echo; HELP=1;;
        esac
        shift
    done

    if [[ $HELP -eq 1 ]]
    then
        echo "$(basename $0) [OPTIONS]"
        echo 
        echo "Convert video files of the local folder to hevc if required."
        echo
        echo "Options:"
        echo "  -h, --help      Print help and quit."
        echo "  --dry-run       Do not convert file."
        return 0
    fi

    local filesize
    local path
    local target
    for path in *
    do
        # check the file is large enough
        filesize=$(stat -c%s "$path")
        [[ "$filesize" -le 520001334 ]] && continue
       
        # check it is not already hevc encoded
        ffprobe -i "$path" 2>&1 | grep -F "Video: hevc" >/dev/null
        [[ $? -eq 0 ]] && continue
        
        #
        target="${path%.*}_hevc.mp4"
        echo "$path" to "$target"

        # convert it
        if [[ $DRY_RUN -eq 0 ]]; then
            ffmpeg -i "$path" -n -c:v libx265 -preset medium -b:v 2600k -x265-params pass=1 -c:a aac -b:a 128k -crf 28 "$target"
        fi
    done
}

main $@
