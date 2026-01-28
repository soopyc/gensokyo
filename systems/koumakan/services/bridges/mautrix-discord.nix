{
  lib,
  config,
  _utils,
  ...
}:
let
  secrets = _utils.setupSecrets config {
    namespace = "mautrix";
    secrets = [
      "doublepuppet/as"
      "doublepuppet/hs"
      "doublepuppet/localpart"

      "discord/avatar_key"
      "discord/media_key"
    ];
  };
  port = 29334;
in
{
  imports = [
    secrets.generate
    (secrets.mkTemplate "mautrix-discord.env" ''
      MDB_AVATAR_KEY=${secrets.placeholder "discord/avatar_key"}
      MDB_MEDIA_KEY=${secrets.placeholder "discord/media_key"}
      MDB_DP_AS_TOKEN=${secrets.placeholder "doublepuppet/as"}
    '')

    (secrets.mkTemplate "mautrix-doublepuppet.yaml" (
      builtins.toJSON {
        id = "mautrix-doublepuppet";
        url = null;
        as_token = secrets.placeholder "doublepuppet/as";
        hs_token = secrets.placeholder "doublepuppet/hs";
        sender_localpart = secrets.placeholder "doublepuppet/localpart";
        rate_limited = false;
        namespaces.users = lib.singleton {
          regex = "@.*:nue\\.soopy\\.moe";
          exclusive = false;
        };
      }
    ))
  ];
  # owner override for template
  sops.templates."mautrix-doublepuppet.yaml".owner = "matrix-synapse";

  services.mautrix-discord = {
    enable = true;
    environmentFile = secrets.getTemplate "mautrix-discord.env";
    settings = {
      # just put most things in the template config here
      # i do not trust the nix module to be complete, but things like db and secret config is fine.
      homeserver = {
        address = "https://nue.soopy.moe";
        domain = "nue.soopy.moe";
        software = "standard";
        status_endpoint = null;
        message_send_checkpoint_endpoint = null;
        async_media = true;
        websocket = false;
      };
      appservice = {
        inherit port;
        address = "http://127.0.0.1:${builtins.toString port}";
        hostname = "127.0.0.1";

        database = {
          type = "sqlite3-fk-wal";
          uri = "file:${config.services.mautrix-discord.dataDir}/data.db?_txlock=immediate";
          max_open_conns = 20;
          max_idle_conns = 2;
          max_conn_idle_time = null;
          max_conn_lifetime = null;
        };

        id = "mautrix_discord";
        bot = {
          username = "discord-bridge";
          displayname = "Discord Bridge Bot";
          avatar = "mxc://maunium.net/nIdEykemnwdisvHbpxflpDlC";
        };
        ephemeral_events = true;
        async_transactions = false;

        # tokens generated/loaded at runtime
      };
      bridge = {
        username_template = "discord_{{.}}";
        displayname_template = "[D]{{if .Webhook}}[hook]{{else if .System}}[sys]{{else if .Bot}}[bot]{{ else if .Application }}[app]{{end}} {{.GlobalName}} ({{.Username}})";
        channel_name_template = "{{if or (eq .Type 3) (eq .Type 4)}}{{.Name}}{{else}}#{{.Name}}{{if .NSFW}} 🔞{{end}}{{end}}";
        guild_name_template = "{{.Name}}";

        private_chat_portal_meta = "default";

        public_address = "https://cfef897c-cbb9-4793-a2e3-6255473744c0.soopy.moe";
        avatar_proxy_key = "$MDB_AVATAR_KEY";
        portal_message_buffer = 128;

        startup_private_channel_create_limit = 5;
        delivery_receipts = false;
        message_status_events = false;
        message_error_notices = true;
        restricted_rooms = true;
        autojoin_thread_on_open = true;
        embed_fields_as_tables = true;
        mute_channels_on_create = false;
        sync_direct_chat_list = false;
        resend_bridge_info = false;
        custom_emoji_reactions = true;
        delete_portal_on_channel_delete = false;
        delete_guild_on_leave = false;
        # federate_rooms = false;
        prefix_webhook_messages = true;
        enable_webhook_avatars = true;
        use_discord_cdn_upload = true;
        proxy = null;
        cache_media = "always";
        direct_media = {
          enabled = true;
          server_name = "cfef897c-cbb9-4793-a2e3-6255473744c0.soopy.moe";
          allow_proxy = true;
          server_key = "$MDB_MEDIA_KEY";
        };
        animated_sticker = {
          target = "webp";
          args = {
            width = 320;
            height = 320;
            fps = 25;
          };
        };
        # i realize this acronym sucks but it's what we have, okay?
        # TODO: fix this when they _finally_ upgrade the discord bridge
        login_shared_secret_map."nue.soopy.moe" = "$MDB_DP_AS_TOKEN";
        double_puppet_allow_discovery = false;

        command_prefix = "!discord";
        management_room_text = {
          welcome = "Welcome to Gensokyo's Discord Bridge bot.";
          welcome_connected = "Use `help` for help, `ping` for status check or `login` to login.";
          welcome_unconnected = "Use `help` for help or `login` to login.";
          additional_help = "For questions, please direct to @sophie:nue.soopy.moe";
        };

        backfill = {
          max_guild_members = 1000;
          forward_limits = {
            initial = lib.genAttrs [ "dm" "channel" ] (lib.const 500);
            missed = lib.genAttrs [ "dm" "channel" "thread" ] (lib.const (-1));
          };
        };

        encryption = {
          allow = true;
          appservice = false;
          msc4190 = true;
          require = false;
          allow_key_sharing = false;
          plaintext_mentions = false;
          delete_keys =
            (lib.genAttrs [
              "dont_store_outbound"
              "ratchet_on_decrypt"
              "delete_on_device_delete"
              "delete_outdated_inbound"
            ] (lib.const false))
            // (lib.genAttrs [
              "delete_fully_used_on_decrypt"
              "periodically_delete_expired"
              "delete_prev_on_new_session"
            ] (lib.const true));

          verification_levels = {
            receive = "unverified";
            send = "unverified";
            share = "cross-signed-tofu";
          };
        };

        provisioning.shared_secret = "disable";

        permissions = {
          "*" = "relay";
          "@sophie:nue.soopy.moe" = "admin";
          "@soopyc:nue.soopy.moe" = "user";
        };
      };
    };
  };

  services.matrix-synapse.settings.app_service_config_files = lib.singleton (
    secrets.getTemplate "mautrix-doublepuppet.yaml"
  );

  services.nginx.virtualHosts."cfef897c-cbb9-4793-a2e3-6255473744c0.soopy.moe" =
    _utils.mkSimpleProxy
      {
        inherit port;
      };
}
