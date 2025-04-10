{ ... }:
{
  services.cjdns = {
    enable = true;

    UDPInterface = {
      bind = "0.0.0.0:61458";
      connectTo = {
        "2.121.148.153:33808" = {
          publicKey = "z3mzc0jksynuuztdlbn0xmpqxnwshpur17k7y7q16rn6fhu57xz0.k";
          password = "faggot";
        };
      };
    };
  };
}
