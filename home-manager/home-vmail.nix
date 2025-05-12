{ ... }:
let
  host = import <host-config>;
in {
  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "24.05";
  home.username = "vmail";
  home.homeDirectory = "/var/vmail";

  # Don't forget to mkdir the MaildirStore Path
  home.file.".mbsyncrc".text = ''
    IMAPAccount protonmail-account
    Host 127.0.0.1
    Port 1143
    User nicolaisingh@pm.me
    Pass ${host.secrets.proton}
    TLSType STARTTLS
    CertificateFile ~/cert.pem

    IMAPStore protonmail-remote
    Account protonmail-account

    MaildirStore protonmail-local
    Path ~/nicolaisingh@pm.me/Maildir/
    Inbox ~/nicolaisingh@pm.me/Maildir/.INBOX/
    Flatten .
    AltMap yes

    Channel protonmail-channel
    Far :protonmail-remote:
    Near :protonmail-local:
    Patterns "*" "!All Mail" "!/INBOX"
    Create Near
    Remove Both
    Expunge Both

    Group protonmail
    Channel protonmail-channel
 '';
}
