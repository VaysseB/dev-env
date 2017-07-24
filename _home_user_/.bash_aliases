

#--------------------------------------
# Créer un dossier $PWD/_save/saveN (avec N un nombre)
# $1, optionel=dossier courant -> dossier à sauvegarder
save_content ()
{
    local HELP

    if [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
        HELP=1
    elif [ "$1" != "" ] && [ "$1" =~ "-" ] && [ "$1" != "--" ]; then
        echo "Unknown switch: $1"
        HELP=1
    fi

    # print help
    if [ "$HELP" == "1" ]; then
        echo "usage: save_content (-h, --help) folder"
        echo
        echo "Save all folder content in a new folder in \"\$folder/_save/saveN\","
        echo "with N the number of the save."
        echo "If no folder is given, use the current folder."
        return
    fi

    # do the thing

    local FICHIERS
    local FOLDER
    local CRT_PATH
    local SAVE_NUM
    local I_FICH

    # recuperation du dossier à sauvegarder
    FOLDER="$1"
    if [ -z "$FOLDER" ]; then
        FOLDER="$(pwd)"
    fi

    # sauvegarde du chemin courant
    CRT_PATH="$(pwd)"
    cd "$FOLDER"

    # creation du dossier
    mkdir --mode=744 --parents "_save"

    # calcul du dossier numero de sauvegarde
    SAVE_NUM=$(echo _save/* | awk 'BEGIN {max=0} { for(i=1; i<=NF; i++) { if (match($i, "/save[0-9]+$")) { num = substr($i, 11); if (num > max) {max = num} } } } END { print max+1 }')

    # creation du dossier
    FINAL_PATH="_save/save""$SAVE_NUM"
    mkdir --mode=744 "$FINAL_PATH"

    # recuperation des fichiers/dossiers
    declare -a FICHIERS
    declare -i I_FICH
    I_FICH=0
    for file in *
    do
        if [ "$file" != "_save" ]; then
            FICHIERS[$I_FICH]="$file"
            I_FICH=$I_FICH+1
        fi
    done
    #echo "Files: ${FICHIERS[@]}"

    # copie des fichiers
    echo "Copying files to ""$FINAL_PATH"
    /bin/cp -u -R -t "$FINAL_PATH" "${FICHIERS[@]}"

    # retour au chemin d'origine
    cd "$CRT_PATH"
}


function grep_all() {
    NB_ARGS="$#"

    if [ "$NB_ARGS" -lt 1 ]; then
        echo "too few arguments, see '--help'"
        return 0
    elif [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
        echo "replace_all [-h|--help] <pattern> [path...]"
        return 0
    fi

    PATTERN="$1"
    if [ -z "$PATTERN" ]; then
        echo "pattern is empty"
        return 1
    fi


    function each_file() {
        while read file; do
            grep -H -n "$PATTERN" "$file"
        done
    }

    # if no path provided
    if [ "$NB_ARGS" -le 1 ]; then
        find . -type f | each_file
    else
        CURR_PATH="2"
        while [ "$CURR_PATH" -le "$NB_ARGS" ]; do
            RUN_PATH="${@:CURR_PATH:1}"
            find "$RUN_PATH" -type f | each_file
            CURR_PATH="$(($CURR_PATH+1))"
        done
    fi
}

function replace_all() {
    NB_ARGS="$#"

    if [ "$NB_ARGS" -lt 1 ]; then
        echo "too few arguments, see '--help'"
        return 1
    elif [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
        echo "replace_all [-h|--help] <old> <new> [path...]"
        return 0
    elif [ "$NB_ARGS" -lt 4 ]; then
        echo "too few arguments, see '--help'"
        return 1
    fi

    PATTERN="$1"
    REPLACE="$2"
    if [ -z "$PATTERN" ]; then
        echo "old content pattern is empty"
        return 1
    fi

    function each_file() {
        while read file; do
            grep -q "$PATTERN" "$file"
            if [ "$?" -eq 0 ]; then
                sed -i 's/'"$PATTERN"'/'"$REPLACE"'/g' "$file"
                grep -n -H "$REPLACE" "$file"
            fi
        done
    }

    # if no path provided
    if [ "$NB_ARGS" -le 2 ]; then
        find . -type f | each_file
    else
        CURR_PATH="3"
        while [ "$CURR_PATH" -le "$NB_ARGS" ]; do
            RUN_PATH="${@:CURR_PATH:1}"
            find "$RUN_PATH" -type f | each_file
            CURR_PATH="$(($CURR_PATH+1))"
        done
    fi
}

alias ls="ls -h -p --color=auto"
alias ll="ls -l -a -h -p --color=auto"

alias steam_purge_conflict_libs="find ~/.local/share/Steam/ubuntu12_32/steam-runtime/i386/usr/lib \( \( -iname 'libxcb.so*' -or -iname 'libstdc++.so*' \) -or \( -iname 'libgcc_s.so*' -or -iname 'libgpg-error.so*' \) \) -print"

function full_update() {
    sudo pip freeze --local | grep -v '^\-e' | cut -d = -f 1  | xargs -n1 pip install -U
	sudo pip3 freeze --local | grep -v '^\-e' | cut -d = -f 1  | xargs -n1 pip3 install -U
	sudo yaourt -Syu
}
