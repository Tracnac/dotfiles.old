{ config, pkgs, ... }:

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  home.stateVersion = "21.05";

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "tracnac";
  home.homeDirectory = "/home/tracnac";

  home.packages = with pkgs; [
    htop wget curl unzip git git-crypt
    gnupg pass pinentry_curses
    pkg-config hyperfine strace meson ctags
    clang_11 clang-analyzer llvm_11
    janet nim nodejs go
    gdb rr lldb
    autoconf automake
  ];

  # Email configuration
  programs.neomutt.enable = true;
  programs.mbsync.enable = true;
  services.mbsync.enable = true;
  services.mbsync.frequency = "*:0/1";
  programs.msmtp.enable = true;
  programs.notmuch = {
    enable = true;
    hooks = {
      preNew = "mbsync --all";
    };
  };

  accounts.email.accounts.tracnac.notmuch.enable = true;
  accounts.email.accounts.tracnac.mbsync.enable = true;
  accounts.email.accounts.tracnac.mbsync.create = "maildir";
  accounts.email.accounts.tracnac.msmtp.enable = true;
  accounts.email.accounts.tracnac.neomutt.enable = true;
  accounts.email.accounts.tracnac.primary = true;
  accounts.email.accounts.tracnac.userName= "tracnac";
  accounts.email.accounts.tracnac.realName= "Tracnac";
  accounts.email.accounts.tracnac.address = "tracnac@devmobs.fr";
  accounts.email.accounts.tracnac.imap.host = "imap.mailfence.com";
  accounts.email.accounts.tracnac.smtp.host = "smtp.mailfence.com";
  accounts.email.accounts.tracnac.passwordCommand = "${pkgs.pass}/bin/pass email";

  programs.git = {
    enable = true;
    userName  = "Tracnac";
    userEmail = "tracnac@devmobs.fr";
  };

  programs.gnupg.agent.pinentryFlavor = "curses";
  programs.gnupg.agent = {
     enable = true;
     enableSSHSupport = true;
  };
}