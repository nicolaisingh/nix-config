{
  lib,
  hostname,
  ...
}:

{
  imports = [
    ./common.nix
  ]
  ++ lib.optionals (hostname == "adonaios") [ ./adonaios ]
  ++ lib.optionals (hostname == "desktop") [ ./yaldabaoth ];
}
