#!/bin/bash
#
# Copyright (C) 2022, 7ym0n
#
# Author: 7ym0n <bb.qnyd@gmail.com>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.
#

install_go()
{
    is_installed go
    if [ $FNRET = 1 ]; then
        install_package go
    else
        if [ $FNRET = 1 ]; then
            crit "golang install failed."
        else
            ok "golang installed."
        fi
    fi
}

go_install_tools()
{
    local PACKAGE=$1
    is_installed go
    if [ $FNRET = 1 ]; then
        crit "must be install golang."
    else
        is_installed $PACKAGE
        if [ $FNRET = 1 ]; then
            if [ $VERBOSE -eq 1 ]
            then
                go install $PACKAGE@latest
            else
                go install $PACKAGE@latest > $LOG_OUTPUT 2>&1
            fi
            if [ $? = 0 ]; then
                FNRET=0
            else
                FNRET=1
            fi
        fi
    fi

    if [ $FNRET = 1 ]; then
        crit "$PACKAGE install failed."
    else
        ok "$PACKAGE installed."
    fi
}

install()
{
    install_go
    go_install_tools golang.org/x/tools/gopls
    go_install_tools golang.org/x/tools/cmd/goimports
    go_install_tools github.com/go-delve/delve/cmd/dlv
    go_install_tools github.com/josharian/impl
    go_install_tools github.com/cweill/gotests/...
    go_install_tools github.com/fatih/gomodifytags
    go_install_tools github.com/davidrjenni/reftools/cmd/fillstruct
    go_install_tools github.com/110y/go-expr-completion
    go_install_tools github.com/golangci/golangci-lint/cmd/golangci-lint
}

upgrade()
{
    upgrade_package go
}

remove()
{
    remove_package go
}

if [ -z "$DOTFAIRY_ROOT_DIR" ]; then
    echo "Cannot source DOTFAIRY_ROOT_DIR variable, aborting."
    exit 128
fi

# Main function, will call the proper functions given the configuration (install, upgrade, remove)
if [ -r $DOTFAIRY_ROOT_DIR/lib/main.sh ]; then
    . $DOTFAIRY_ROOT_DIR/lib/main.sh
else
    echo "Cannot find main.sh, have you correctly defined your root directory?"
    exit 128
fi
