{
  pkgs,
  _utils,
  ...
}:
{
  services.roundcube = {
    enable = true;
    package = pkgs.roundcube.withPlugins (
      plugins: with plugins; [
        carddav
        contextmenu
      ]
    );
    dicts = with pkgs.aspellDicts; [ en ];
    hostName = "webmail.soopy.moe";

    extraConfig = ''
      // ssl means implicit tls, NOT ssl. see roundcube docs for details.
      $config['imap_host'] = [
        'ssl://mx2.soopy.moe:993' => 'Gensokyo Mail Exchange',
      ];
      // TODO: setup smtp and add related stuff here
      $config['product_name'] = 'GensoNet Webmail';
      $config['support_url'] = 'https://soopy.moe';
      $config['prefer_html'] = false;
      $config['plugins'] = [
        'archive',
        'emoticons',
        'filesystem_attachments',
        'hide_blockquote',
        'identicon',
        'newmail_notifier',
        'reconnect',
        'carddav',
        'managesieve',
      ];
    '';
  };

  services.nginx.virtualHosts."webmail.soopy.moe" = _utils.mkVhost {
    enableACME = false;
    useACMEHost = "kita-web.c.soopy.moe";
  };
}
