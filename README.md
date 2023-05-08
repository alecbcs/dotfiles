# dotfiles
by Alec Scott and [Todd Gamblin](https://github.com/tgamblin/dotfiles)

## Table of Contents
- [Bash Config](/home/.bashrc)
- [Emacs Config](/home/.emacs.d)
  - [Programming Languages](/home/.emacs.d/init/init-prog-langs.el)
  - [Markdown](/home/.emacs.d/init/init-markdown.el)
  - [Org](/home/.emacs.d/init/init-org.el)
  - [Podman](/home/.emacs.d/init/init-podman.el)
  - [LSP](/home/.emacs.d/init/init-lsp.el)
- [Git Config](/home/.gitconfig)
- [ZSH Config](/home/.zshrc)
- [ZSH Env](/home/.zshenv)

## Getting Started
To get started there are three easy steps:

1. Fork this repo, then clone your fork to your computer.
2. Put your dotfiles in `home/` and check them in.
3. Run the `link` script to create symbolic links in your home directory.

Now your dotfiles are in a git repo and you can clone them anywhere and keep
them synchronized.

#### Linking in Your Dotfiles on a New Computer
```console
alec@laptop dotfiles % ./link
linking dotfiles
  from: /Users/alecbcs/src/dotfiles/home
  into: /Users/alecbcs

# exclude a file/directory
alec@laptop dotfiles % ./link -e .emacs.d
```

If something goes wrong, not to worry.  `link` keeps backups in `~/.dotfiles-backup`.  You can run `unlink` to delete all the symbolic links and put your old config files back where they were:

#### Unlinking Your Dotfiles from a Computer
```console
alec@laptop dotfiles % ./unlink
unlinking dotfiles
  from: /Users/alecbcs/src/dotfiles/home
  into: /Users/alecbcs
```
