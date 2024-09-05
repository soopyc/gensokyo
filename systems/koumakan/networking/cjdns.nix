{...}: {
  services.cjdns = {
    enable = true;

    UDPInterface = {
      bind = "219.78.37.97:61458";
      connectTo = {
        dawn = {
          hostname = "2.121.148.153:33808";
          publicKey = "z3mzc0jksynuuztdlbn0xmpqxnwshpur17k7y7q16rn6fhu57xz0.k";
          password = "faggot";
        };
      };
    };
  };
}
