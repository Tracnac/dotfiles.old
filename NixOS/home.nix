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
    gnupg
    pkg-config hyperfine strace meson ctags
    clang_11 clang-analyzer llvm_11
    janet nim nodejs go
    gdb rr lldb
    autoconf automake
  ];

  programs.git = {
    enable = true;
    userName  = "Tracnac";
    userEmail = "tracnac@devmobs.fr";
  };

  programs.emacs = {
    enable = true;
    extraPackages = (epkgs: (with epkgs; [
      nix-mode
      magit
      projectile
      counsel
      helpful
      smartparens
      rainbow-delimiters
      undo-tree
      doom-modeline
      all-the-icons
    ]));
  };

  programs.vim = {
    enable = true;
    extraConfig = ''
      let g:airline#extensions#tabline#enabled = 1
      let g:airline_powerline_fonts=1
      let g:airline_theme='nord'
      " RainBow
      let g:rainbow_active = 1
      " My prefs
      set backspace=indent,eol,start
      set nocompatible
      set noerrorbells visualbell t_vb=
      set number
      if exists('+relativenumber')
        set relativenumber
        :augroup numbertoggle
        :  autocmd!
        :  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
        :  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
        :augroup END
      endif
      set nowrap
      set wildmenu
      set et ts=2 sts=2 sw=2
      set encoding=UTF-8
      set ruler
      set rulerformat=%-14.(%l,%c%V%)\ %P
      set noshowmode
      set smartindent

      " Search option
      set hlsearch
      set ignorecase
      set smartcase
      set showmatch

      " Appearance
      set t_Co=256
      colorscheme nord
      set statusline+=%#warningmsg#
      set statusline+=%*

      " Shortcut
      nnoremap  <silent> <tab>    :if &modifiable && !&readonly && &modified <CR> :write<CR> :endif<CR>:bnext<CR>
      nnoremap  <silent> <s-tab>  :if &modifiable && !&readonly && &modified <CR> :write<CR> :endif<CR>:bprevious<CR>
      nnoremap  <silent> <CR>     :nohlsearch<CR>
    '';
    
    settings = {
    };

    plugins = with pkgs.vimPlugins; [
      sensible
      vim-airline
      vim-airline-themes
      vim-surround
      rainbow
      YankRing-vim
      nord-vim
    ];
  };
}
