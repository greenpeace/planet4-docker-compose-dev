# Store this file in /etc/bash_completion.d/composer

_composer_scripts() {
    local cur prev
    _get_comp_words_by_ref -n : cur

    COMPREPLY=()
    prev="${COMP_WORDS[COMP_CWORD-1]}"

    #
    #  Complete the arguments to some of the commands.
    #
    if [ "$prev" != "composer" ] ; then
        local opts=$(composer $prev -h --no-ansi | tr -cs '[=-=][:alpha:]_' '[\n*]' | grep '^-')
        COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
        return 0
    fi


    if [[ "$cur" == -* ]]; then
        COMPREPLY=( $( compgen -W '-h -q -v -V -n -d \
            --help --quiet --verbose --version --ansi --no-ansi \
            --no-interaction --profile --working-dir' -- "$cur" ) )
    else
        local scripts=$(composer --no-ansi 2> /dev/null |  awk '/^ +[a-z]+/ { print $1 }')
        COMPREPLY=( $(compgen -W "${scripts}" -- ${cur}) )
    fi

    __ltrim_colon_completions "$cur"
    return 0
}

complete -F _composer_scripts composer