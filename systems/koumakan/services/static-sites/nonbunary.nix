{_utils, ...}: {
  services.nginx.virtualHosts."nonbunary.soopy.moe" = _utils.mkVhost {
    locations."/".return = "404";
    locations."= /" = _utils.mkNginxFile {
      content = ''
        <!doctype html>
        <html lang="en">
          <body>
            <svg xmlns="http://www.w3.org/2000/svg" width="300" height="200">
            <path fill="#2D2D2D" d="m0,0h300v200H0"/>
            <path fill="#9B59D0" d="m0,0h300v150H0"/>
            <path fill="#FFFFFF" d="m0,0h300v100H0"/>
            <path fill="#FFF433" d="m0,0h300v50H0"/>
            </svg>
          </body>
        </html>
      '';
    };
  };
}
