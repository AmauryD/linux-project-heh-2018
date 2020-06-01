function edit_config_file () {
	local CONFIG_FILE=$1 
	local FIELD=$2
	local VALUE=$3

	#some regex 
	sed -c -i "s/\($FIELD *= *\).*/\1$VALUE/" $CONFIG_FILE
}

function add_line_if_not_exist()
{
	local LAST_LINE=`tail -1 $2`

	#creates a new line to echo if last line of the file is not empty
	if [[ -n $LAST_LINE ]]; then 
		echo >> $2
	fi

	grep -q -F $1 $2 || printf "$1" >> $2
}

function replace_var()
{
	sed -i -e "s|\${$1}|$2|g" $3
}

function copy_template_file()
{
	echo "Copying $1 to $2" >&2
	cp "templates/$1" $2
	chmod 600 $2
}