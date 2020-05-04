# #############################################
# The MIT License (MIT)
#
# Copyright © 2020 Michael Czapski
# #############################################

declare -u fn__CreateWindowsShortcut="SOURCED"

## ########################################################################
## create a windows 10 shortcut
## ########################################################################

export fn__CreateWindowsShortcut__RUN_NORMAL_WINDOW=0
export fn__CreateWindowsShortcut__RUN_MAXIMISED=3
export fn__CreateWindowsShortcut__RUN_MINIMISED=7

function fn__CreateWindowsShortcut() {
  pShortcutPath=${1?"Usage: ${0} requires Shortcut Name as 1st argument"}
  TargetPath=${2?"Usage: ${0} requires full windows path to executable as 2nd argument"}
  WorkingDirectory=${3?"Usage: ${0} requires windows path in which to run as 3rd argument"}
  pWindowStyle=${4?"Usage: ${0} requires window style 7=minimised, 0=windowed as 4th argument"}
  pIconLocation=${5?"Usage: ${0} requires full windows path to icon source as 5th argument"}
  pArguments=${6?"Usage: ${0} requires string of arguments to the xecutable, if any, as 6th argument"}

  # echo \
  powershell.exe "
  \$s=(New-Object -COM WScript.Shell).CreateShortcut('${pShortcutPath}');\
  \$s.TargetPath='${TargetPath}';\
  \$s.WorkingDirectory='${WorkingDirectory}';\
  \$s.WindowStyle=${pWindowStyle};\
  \$s.IconLocation='${pIconLocation}';\
  \$s.Arguments='${pArguments}';\
  \$s.Save()\
  "
}




:<<-'EXAMPLES---------------------------------------------------------------------'

__ARGS='/c wsl -d Debian -- bash -lc "docker.exe container exec -itu node --workdir /home/node nodejs_test bash -l"'
fn__CreateWindowsShortcut \
  "..\run shell as node in container.lnk" \
  "C:\Windows\System32\cmd.exe" \
  "%~dp0" \
  "${fn__CreateWindowsShortcut__RUN_NORMAL_WINDOW}" \
  "C:\Windows\System32\wsl.exe" \
  "${__ARGS}"


__ARGS='/c wsl -d Debian -- bash -lc "docker.exe container exec -itu root --workdir /home/node nodejs_test bash -l"'
fn__CreateWindowsShortcut \
  "..\run shell as root in container.lnk" \
  "C:\Windows\System32\cmd.exe" \
  "%~dp0" \
  "${fn__CreateWindowsShortcut__RUN_NORMAL_WINDOW}" \
  "C:\Windows\System32\wsl.exe" \
  "${__ARGS}"


__ARGS=""
fn__CreateWindowsShortcut \
  "wsl shell.lnk" \
  "C:\Windows\System32\wsl.exe" \
  "%~dp0" \
  "${fn__CreateWindowsShortcut__RUN_NORMAL_WINDOW}" \
  "C:\Windows\System32\wsl.exe" \
  "${__ARGS}"


## C:\Windows\System32\cmd.exe /c wsl -d Debian -- bash -lc "docker.exe container exec --workdir /home/node -itu root lesson_$(cat __h.parent) ash -l"

__ARGS='/c wsl -d Debian -- bash -lc "docker.exe container exec -itu root --workdir /home/node nodejs_test bash -l"'
fn__CreateWindowsShortcut \
  "run shell as node in container.lnk" \
  "C:\Windows\System32\cmd.exe" \
  "%~dp0" \
  "${fn__CreateWindowsShortcut__RUN_NORMAL_WINDOW}" \
  "C:\Windows\System32\wsl.exe" \
  "${__ARGS}"


## C:\Windows\System32\cmd.exe /c wsl -d Debian -- bash -lc "docker.exe container exec --workdir /home/node -itu node lesson_$(cat __h.parent) ash -l"

__ARGS='/c wsl -d Debian -- bash -lc "docker.exe container exec -itu root --workdir /home/node nodejs_test bash -l"'
fn__CreateWindowsShortcut \
  "run shell as node in container.lnk" \
  "C:\Windows\System32\cmd.exe" \
  "%~dp0" \
  "${fn__CreateWindowsShortcut__RUN_NORMAL_WINDOW}" \
  "C:\Windows\System32\wsl.exe" \
  "${__ARGS}"


## "%ProgramFiles%\Microsoft VS Code\Code.exe" --folder-uri ""

__ARGS="--folder-uri \"${folderUri}\""
fn__CreateWindowsShortcut \
  "10 code in remote container.lnk" \
  "%ProgramFiles%\Microsoft VS Code\Code.exe" \
  "%~dp0" \
  "${fn__CreateWindowsShortcut__RUN_MINIMISED}" \
  "%ProgramFiles%\Microsoft VS Code\Code.exe" \
  "${__ARGS}"

EXAMPLES---------------------------------------------------------------------