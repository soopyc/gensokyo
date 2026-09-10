{
  hjem.users.cassie.xdg.config.files."hjem-zsh-glue.zsh".text = ''
    compress_video() {
      if test "$#" -lt 1; then
        echo "must specify one source parameter, or one source + one sseof param."
        return 1
      fi

      spath=$1; shift
      sname="$(basename "$spath")"

      sseof=
      if test "$1" != ""; then sseof="-sseof $1"; fi

      ffmpeg \
        ''${=sseof}\
        -i $spath -c:v libsvtav1 -preset 5 -b:v 3500k \
        "./''${sname%%.*}-compressed.webm"
      return 0
    }

    export compress_video

    # random aliases
    alias pw="packwiz"
    alias klogout="qdbus org.kde.LogoutPrompt /LogoutPrompt promptLogout"
    alias kreboot="qdbus org.kde.LogoutPrompt /LogoutPrompt promptReboot"
  '';
}
