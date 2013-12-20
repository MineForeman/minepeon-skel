# /etc/bash.bashrc
#
# https://wiki.archlinux.org/index.php/Color_Bash_Prompt
#
# This file is sourced by all *interactive* bash shells on startup,
# including some apparently interactive shells such as scp and rcp
# that can't tolerate any output. So make sure this doesn't display
# anything or bad things will happen !

# Test for an interactive shell. There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.

# If not running interactively, don't do anything!
[[ $- != *i* ]] && return

# Bash won't get SIGWINCH if another process is in the foreground.
# Enable checkwinsize so that bash will check the terminal size when
# it regains control.
# http://cnswww.cns.cwru.edu/~chet/bash/FAQ (E11)
shopt -s checkwinsize

# Enable history appending instead of overwriting.
shopt -s histappend

case ${TERM} in
        xterm*|rxvt*|Eterm|aterm|kterm|gnome*)
                PROMPT_COMMAND=${PROMPT_COMMAND:+$PROMPT_COMMAND; }'printf "\033]0;%s@%s:%s\007" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/~}"'
                ;;
        screen)
                PROMPT_COMMAND=${PROMPT_COMMAND:+$PROMPT_COMMAND; }'printf "\033_%s@%s:%s\033\\" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/~}"'
                ;;
esac

# fortune is a simple program that displays a pseudorandom message
# from a database of quotations at logon and/or logout.
# If you wish to use it, please install "fortune-mod" from the
# official repositories, then uncomment the following line:

# [[ "$PS1" ]] && /usr/bin/fortune


# edit #2
# Welcome Message
# Arch Linux Logo Welcome Message
c1="$(tput sgr0)$(tput setaf 4)"
c2="$(tput bold)$(tput setaf 4)"
c3="$(tput bold)$(tput setaf 7)"
echo
echo "$c2            _                                   "
echo "$c2           (_)                                  "
echo "$c2  _ __ ___  _ _ __   ___ _ __   ___  ___  _ __  "
echo "$c2 |  _   _ \| |  _ \ / _ \  _ \ / _ \/ _ \|  _ \ "
echo "$c2 | | | | | | | | | |  __/ |_) |  __/ (_) | | | |"
echo "$c2 |_| |_| |_|_|_| |_|\___|  __/ \___|\___/|_| |_|"
echo "$c2                        | |                     "
echo "$c2                        |_|"
echo "$c3 An ARM arch linux-based mining platform, designed"
echo "$c3 for ARM microcomputers."
echo
echo "$c3 Peon's in feudal times were indentured vassals, often"
echo "$c3 assgined dangerous, tedious and unpleasant work,"
echo "$c3 like mining.  -- The MineForeman"
echo "$(tput sgr0)"$'\n'

# Show date
DATE="$(tput setaf 1)[$(tput setaf 6)$(date)"
DATE="${DATE}$(tput setaf 1)]"
echo $DATE
# Show kernel info
KERNEL="$(tput setaf 1)[$(tput setaf 6)$(uname -srmn)"
KERNEL="${KERNEL}$(tput setaf 1)]"
echo "$KERNEL"$'\n'

# show IP address
WLAN_IP=$(ifconfig wlan0 | grep -w inet | awk {'print $2'} | sed s/.*:// )
ETH_IP=$(ifconfig eth0 | grep -w inet | awk {'print $2'} | sed s/.*:// )
echo "wlan0 IP:$WLAN_IP"
echo "eth0 IP:$ETH_IP"
echo

# Set colorful PS1 only on colorful terminals.
# dircolors --print-database uses its own built-in database
# instead of using /etc/DIR_COLORS. Try to use the external file
# first to take advantage of user additions. Use internal bash
# globbing instead of external grep binary.

# sanitize TERM:
safe_term=${TERM//[^[:alnum:]]/?}
match_lhs=""

[[ -f ~/.dir_colors ]] && match_lhs="${match_lhs}$(<~/.dir_colors)"
[[ -f /etc/DIR_COLORS ]] && match_lhs="${match_lhs}$(</etc/DIR_COLORS)"
[[ -z ${match_lhs} ]] \
        && type -P dircolors >/dev/null \
        && match_lhs=$(dircolors --print-database)

if [[ $'\n'${match_lhs} == *$'\n'"TERM "${safe_term}* ]] ; then

        # we have colors :-)

        # Enable colors for ls, etc. Prefer ~/.dir_colors
        if type -P dircolors >/dev/null ; then
                if [[ -f ~/.dir_colors ]] ; then
                        eval $(dircolors -b ~/.dir_colors)
                elif [[ -f /etc/DIR_COLORS ]] ; then
                        eval $(dircolors -b /etc/DIR_COLORS)
                fi
        fi

        PS1="$(if [[ ${EUID} == 0 ]]; then echo '\[\033[01;31m\]\h'; else echo '\[\033[01;32m\]\u@\h'; fi)\[\033[01;34m\] \w \$([[ \$? != 0 ]] && echo \"\[\033[01;31m\]:(\[\033[01;34m\] \")\\$\[\033[00m\] "

        # Use this other PS1 string if you want \W for root and \w for all other users:
        # PS1="$(if [[ ${EUID} == 0 ]]; then echo '\[\033[01;31m\]\h\[\033[01;34m\] \W'; else echo '\[\033[01;32m\]\u@\h\[\033[01;34m\] \w'; fi) \$([[ \$? != 0 ]] && echo \"\[\033[01;31m\]:(\[\033[01;34m\] \")\\$\[\033[00m\] "

        alias ls="ls --color=auto"
        alias dir="dir --color=auto"
        alias grep="grep --color=auto"
        alias dmesg='dmesg --color'

        # Uncomment the "Color" line in /etc/pacman.conf instead of uncommenting the following line...!

        # alias pacman="pacman --color=auto"

else

        # show root@ when we do not have colors

        PS1="\u@\h \w \$([[ \$? != 0 ]] && echo \":( \")\$ "

        # Use this other PS1 string if you want \W for root and \w for all other users:
        # PS1="\u@\h $(if [[ ${EUID} == 0 ]]; then echo '\W'; else echo '\w'; fi) \$([[ \$? != 0 ]] && echo \":( \")\$ "

fi

PS2="> "
PS3="> "
PS4="+ "

# Try to keep environment pollution down, EPA loves us.
unset safe_term match_lhs

# Try to enable the auto-completion (type: "pacman -S bash-completion" to install it).
[ -r /usr/share/bash-completion/bash_completion ] && . /usr/share/bash-completion/bash_completion

# Try to enable the "Command not found" hook ("pacman -S pkgfile" to install it).
# See also: https://wiki.archlinux.org/index.php/Bash#The_.22command_not_found.22_hook
[ -r /usr/share/doc/pkgfile/command-not-found.bash ] && . /usr/share/doc/pkgfile/command-not-found.bash

