# Set paths.
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DIR_ROOT="$(dirname "$DIR")"
DIR_BASH=$DIR_ROOT/bash
DIR_FE=$DIR_ROOT/fe
DIR_PYTHON=$DIR_ROOT
DIR_PYTHON_VENV=$DIR_ROOT/venv

# Inform user.
echo
echo "# my arguments ------------->  ${@}     "
echo "# my path  ----------------->  ${0}     "
echo "# my parent path ----------->  ${0%/*}  "
echo "# my name ------------------>  ${0##*/} "
echo "# prodiguer python path ---->  ${DIR_PYTHON}  "
echo "# prodiguer venv path ------>  ${DIR_PYTHON_VENV}  "
echo "# prodiguer tests path ----->  ${DIR_TESTS}  "
echo "# command module ----------->  ${MOD}  "
echo "# command ------------------>  ${OP}  "
echo


# Set Legal notice.
DISCLAIMER="/*!
 * esdoc-js-client - javascript Library vVERSION
 * https://github.com/ES-DOC/esdoc-js-client
 *
 * Copyright YEAR, ES-DOC (http://esdocumentation.org)
 *
 * Licensed under the following licenses:.
 *     CeCILL       http://www.cecill.info/licences/Licence_CeCILL_V2-en.html
 *     GPL v3       http://www.gnu.org/licenses/gpl.html
 *
 * Date: DATE
 */
"
DISCLAIMER=${DISCLAIMER/VERSION/$VERSION}
DISCLAIMER=${DISCLAIMER/YEAR/$(date +%Y)}
DISCLAIMER=${DISCLAIMER/DATE/$(date -u)}


# Set javascript fileset (N.B. order is important).
JS=(
    'app/main.js'
    'app/constants.js'
    'app/options.js'
    'app/utils.js'
    'sm/main.js'
    'sm/webSocket.js'
    'sm/state.js'
    'sm/view.Filter.js'
    'sm/view.Grid.js'
    'sm/view.Notifications.js'
    'sm/view.Main.js'
)

# ---------------------------------------------------------
# STEP 1 : Minimize.
# ---------------------------------------------------------

minify_js()
{
    echo IPSL :: PRODIGUER :: minimizing js files

	for f in "${JS[@]}"
	do
		source="$SRC$f"
		printf "\t\t%s\n" "$source"
		dest="$TMP$f"
		java -jar $YUICOMPRESSOR $source -o $dest --nomunge
	done
}

	


setup_python()
{
    echo IPSL :: PRODIGUER :: setting python path

	export PYTHONPATH=$PYTHONPATH:$DIR_PYTHON
	source $DIR_PYTHON_VENV/bin/activate
}




exit 0