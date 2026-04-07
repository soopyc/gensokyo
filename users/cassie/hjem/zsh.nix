{
  hjem.users.cassie.xdg.config.files."hjem-zsh-glue.zsh".text = ''
    compress_video() {
      if ! test "$#" -eq 1; then
        echo "must specify only one source parameter."
        return 1
      fi

      spath=$1; shift
      sname="$(basename "$spath")"

      ffmpeg -i $spath -c:v libsvtav1 -preset 5 -b:v 1000k "./''${sname%%.*}-compressed.webm"
      return 0
    }

    export compress_video
  '';
}
