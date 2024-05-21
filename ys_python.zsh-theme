# Clean, simple, compatible and meaningful.
# Tested on Linux, Unix and Windows under ANSI colors.
# It is recommended to use with a dark background.
# Colors: black, red, green, yellow, *blue, magenta, cyan, and white.
#
# Mar 2013 Yad Smood

# VCS
YS_VCS_PROMPT_PREFIX1=" %{$reset_color%}[%{$fg[blue]%}"
YS_VCS_PROMPT_PREFIX2=":%{$fg[cyan]%}"
YS_VCS_PROMPT_SUFFIX="%{$reset_color%}]"
YS_VCS_PROMPT_DIRTY=" %{$fg[red]%}x"
YS_VCS_PROMPT_CLEAN=" %{$fg[green]%}o"

# Git info
local git_info='$(git_prompt_info)'
ZSH_THEME_GIT_PROMPT_PREFIX="${YS_VCS_PROMPT_PREFIX1}git${YS_VCS_PROMPT_PREFIX2}"
ZSH_THEME_GIT_PROMPT_SUFFIX="$YS_VCS_PROMPT_SUFFIX"
ZSH_THEME_GIT_PROMPT_DIRTY="$YS_VCS_PROMPT_DIRTY"
ZSH_THEME_GIT_PROMPT_CLEAN="$YS_VCS_PROMPT_CLEAN"

# SVN info
local svn_info='$(svn_prompt_info)'
ZSH_THEME_SVN_PROMPT_PREFIX="${YS_VCS_PROMPT_PREFIX1}svn${YS_VCS_PROMPT_PREFIX2}"
ZSH_THEME_SVN_PROMPT_SUFFIX="$YS_VCS_PROMPT_SUFFIX"
ZSH_THEME_SVN_PROMPT_DIRTY="$YS_VCS_PROMPT_DIRTY"
ZSH_THEME_SVN_PROMPT_CLEAN="$YS_VCS_PROMPT_CLEAN"

# HG info
local hg_info='$(ys_hg_prompt_info)'
ys_hg_prompt_info() {
	# make sure this is a hg dir
	if [ -d '.hg' ]; then
		echo -n "${YS_VCS_PROMPT_PREFIX1}hg${YS_VCS_PROMPT_PREFIX2}"
		echo -n $(hg branch 2>/dev/null)
		if [[ "$(hg config oh-my-zsh.hide-dirty 2>/dev/null)" != "1" ]]; then
			if [ -n "$(hg status 2>/dev/null)" ]; then
				echo -n "$YS_VCS_PROMPT_DIRTY"
			else
				echo -n "$YS_VCS_PROMPT_CLEAN"
			fi
		fi
		echo -n "$YS_VCS_PROMPT_SUFFIX"
	fi
}

# Virtualenv

YS_THEME_VIRTUALENV_PROMPT_PREFIX="%{$fg[green]%}("
YS_THEME_VIRTUALENV_PROMPT_SUFFIX=")%{$reset_color%}%  "

local venv_info='$(virtenv_prompt)'
virtenv_prompt() {
	[[ -n "${VIRTUAL_ENV:-}" ]] || return
	echo "${YS_THEME_VIRTUALENV_PROMPT_PREFIX}${VIRTUAL_ENV:t}${YS_THEME_VIRTUALENV_PROMPT_SUFFIX}"
}

# Conda env
OLD_PS1="$PS1"
CONDA_PREFIX="%{$fg[red]%}("
CONDA_SUFFIX=")%{$reset_color%} "
ZSH_THEME_CONDA_PREFIX="$CONDA_PREFIX"
ZSH_THEME_CONDA_SUFFIX="$CONDA_SUFFIX"

local conda_info='$(conda_env_info)'
conda_env_info() {
	if [[ "${CONDA_DEFAULT_ENV}" != "" ]]; then
		PS1="$OLD_PS1"
		if [[ "${CONDA_DEFAULT_ENV}" == */* ]]; then
			echo "${ZSH_THEME_CONDA_PREFIX}$(basename "${CONDA_DEFAULT_ENV}")${ZSH_THEME_CONDA_SUFFIX}"
		else
			echo "${ZSH_THEME_CONDA_PREFIX}${CONDA_DEFAULT_ENV}${ZSH_THEME_CONDA_SUFFIX}"
		fi
	fi
}

local exit_code="%(?,,C:%{$fg[red]%}%?%{$reset_color%})"

# Prompt format:
#
# PYTHON ENVIRONMENT [DIRECTORY] [git:BRANCH STATE] [TIME] C:LAST_EXIT_CODE
# $ COMMAND
#
# For example:
#
# # (env) [~/.oh-my-zsh] [git:master x] [21:47:42] C:0
# $
PROMPT="
[%*] \
${conda_info}\
${venv_info}\
[%{$terminfo[bold]$fg[yellow]%}%1~%{$reset_color%}]\
${hg_info}\
${git_info}\
${svn_info}\
 \
$exit_code
%{$terminfo[bold]$fg[red]%}$ %{$reset_color%}"
