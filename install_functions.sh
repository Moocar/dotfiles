function backup {
    local file="$1"
    if [[ -L "$file" ]]; then
        rm "$file"
    elif [[ -e "$file" ]]; then
        mv "$file" "$file.bak"
    fi
}

function link_with_backup {
    local filename="$1"
    local source="$DOTFILES/$filename"
    local target="$HOME/$filename"
    backup "$target"
    ln -s "$source" "$target"
}

function install_elpa {
    rm -rf "$DOTFILES/.emacs.d/elpa"
    emacs --script "$DOTFILES/install_elpa.el"
}

function update_submodules {
    git submodule init
    git submodule update
}

function compile_local_emacs_lisp {
    emacs -batch -f batch-byte-recompile-directory "$DOTFILES/.emacs.d/local"
}

# SSH autocomplete depends on ~/.ssh/config and known_hosts existing
function create_ssh_config {
    mkdir -p "$HOME/.ssh"
    for file in config known_hosts; do
        if [ ! -e "$HOME/.ssh/$file" ]; then
            touch "$HOME/.ssh/$file"
        fi
    done
}

function unset_git_user {
    for var in user.name user.email user.initials; do
        if ( git config --list --global | grep "$var" &> /dev/null ); then
            git config --global --unset "$var"
        fi
    done
}

function symlink_emacs {
cat <<EOF > "/usr/local/bin/emacs"
#!/bin/sh
/Applications/Emacs.app/Contents/MacOS/Emacs
EOF
chmod +x "/usr/local/bin/emacs"
}

function write_home_path_file {
    cat <<EOF > "$HOME/.path"
$HOME/bin
/usr/local/bin
/opt/local/bin
/usr/bin
/bin
/usr/sbin
/sbin
/opt/X11/bin
/usr/texbin
EOF
}
