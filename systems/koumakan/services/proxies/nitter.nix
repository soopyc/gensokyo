{
  _utils,
  ...
}: {
  services.nginx.virtualHosts."nitter.soopy.moe" = _utils.mkVhost {
    locations."/" = _utils.mkNginxFile {
      content = ''
        <!doctype html>
        <html>
          <head>
            <title>NSM is EOL</title>
            <meta name="viewport" content="width=device-width, initial-scale=1" />
            <style>
              :root { font-family: monospace; }
            </style>
          </head>
          <body>
            <h1>nitter.soopy.moe (NSM) is end-of-life.</h1>
            <p>Due to recent further enshittification of Twitter by That Guy You Know And Love, nitter instances across the globe stopped working.</p>
            <p>To avoid potential lawsuits against us, we are unable to host this service any further.</p>
            <p>We would like to mention that we are physically a one (1) person team, and there's only so much time for us to work on stuff like this.</p>
            <p>
              Nevertheless, We thank you for your patronage of our services, and our deepest gratitude goes to everyone who helped create
              Nitter, those who figured out solutions since the first API change, and the many who ran all the public instances.
            </p>
            <p>All good things in this society will inevitably end one way or another. So long, and thanks for all the fish.</p>

            <hr />
            <p>Additional readings</p>
            <ul>
              <li><a href="https://status.d420.de/rip">death message from 0xpr03, hoster of nitter.d420.de</a></li>
              <li><a href="https://nitter.cz/">statement from nolog, hoster of nitter.cz</a></li>
              <li><a href="https://words.soopy.moe/kmk-dailies/3821743-dead-nitter-instances-or-i-am-so-tired">our own (bad) take of this</a></li>
            </ul>
          </body>
        </html>
      '';
    };

    locations."~ /about" = _utils.mkNginxFile {
      content = ''
        <!doctype html>
        <html>
        <body>
        <!-- yes i am putting style element in the body you can't do anything about it -->
        <style>:root {font-family:monospace;font-size:2em;}</style>
        <!-- This is just a hack to get whatever we want to be put on status.d420.de, sorry! -->
        <p style="display:none;">Version <a href="/rip">NitterIsDead-0000</a></p>
        <p>you aren't supposed to be here 🤨</p>
        <p><a href="/">go home NOW</a></p>
        </body>
        </html>
      '';
    };
  };
}
