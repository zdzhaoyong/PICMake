#. ~/.bashrc // why source not usable?
while read line
do
  if [[ $line == "PICMAKE_COMPLETION_ENABLED=ON" ]];then
    PICMAKE_COMPLETION_ENABLED=ON
  fi
done < ~/.bashrc


if [ -z "$PICMAKE_COMPLETION_ENABLED" ];then
echo '
# picmake tab completion support
function_picmake_complete()
{
    COMPREPLY=()
    local cur=${COMP_WORDS[COMP_CWORD]};
    local com=${COMP_WORDS[COMP_CWORD-1]};
    local can=$(${COMP_WORDS[*]:0:COMP_CWORD} -help -complete_function_request)
    local reg="-.+"
    if [[ $com =~ $reg ]];then
      COMPREPLY=($(compgen -df -W "$can" -- $cur))
    else
      COMPREPLY=($(compgen -W "$can" -- $cur))
    fi
}

complete -F function_picmake_complete "picmake"
PICMAKE_COMPLETION_ENABLED=ON
'>> ~/.bashrc
else
  echo "PICMake tab completion has already supported."
fi


