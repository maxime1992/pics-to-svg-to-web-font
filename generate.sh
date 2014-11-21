#!/bin/bash

# ----------------------------
# How to launch the script (examples)
# bash ./script.sh ./base gif
# bash ./script.sh ./base png
# ----------------------------

# CHECK NEEDED SOFTS/LIBRAIRIES
# check if fontcustom is installed
fontcustom >/dev/null 2>&1 || {
	echo "The script require fontcustom but it's not installed"

	while true; do
	    read -p "Do you want to install it ? (Y/N) : " yn
	    case $yn in
	        [Yy]* ) mkdir tmp_install_fontcustom; cd tmp_install_fontcustom; sudo apt-get install -y zlib1g-dev ruby-dev fontforge; wget http://people.mozilla.com/~jkew/woff/woff-code-latest.zip; unzip woff-code-latest.zip -d sfnt2woff && cd sfnt2woff && make && sudo mv sfnt2woff /usr/local/bin/; cd ../../fontcustom/bin; sudo gem install fontcustom; rm -rf tmp_install_fontcustom; break;;
	        [Nn]* ) exit;;
	        * ) echo "Please answer Y or N.";;
	    esac
	done
}

# check if imagemagick is installed
convert -version >/dev/null 2>&1 || {
	echo "The script require imagemagick but it's not installed"

	while true; do
	    read -p "Do you want to install it ? (Y/N) : " yn
	    case $yn in
	        [Yy]* ) sudo apt-get install -y imagemagick; break;;
	        [Nn]* ) exit;;
	        * ) echo "Please answer Y or N.";;
	    esac
	done
}

# check if potrace is installed
potrace -v >/dev/null 2>&1 || {
	echo >&2 "The script require potrace but it's not installed"

	while true; do
	    read -p "Do you want to install it ? (Y/N) : " yn
	    case $yn in
	        [Yy]* ) sudo apt-get install -y potrace; break;;
	        [Nn]* ) exit;;
	        * ) echo "Please answer Y or N.";;
	    esac
	done
}
# END OF CHECK NEEDED SOFTS/LIBRAIRIES

# is the script launched with all params ?
if [ $# -ne 2 ]; then
	echo "Missing arguments."
	exit 1
fi

# does directory containing files to convert exists ?
if [ ! -d $1 ]; then
	# directory does not exists
	echo "Directory containing files to convert does not exists."
	exit 2
fi

# save directory into var
directory=$1

# which type of pics do you want to handle ?
pic_type=$2

# delete old temporary folders and create them, empty
if [ -d ./conv_tmp ]; then
	rm -rf ./conv_tmp
fi

mkdir ./conv_tmp

if [ -d ./conv_tmp_svg ]; then
	rm -rf ./conv_tmp_svg
fi

mkdir ./conv_tmp_svg

if [ -d ./final_svg ]; then
	rm -rf ./final_svg
fi

mkdir ./final_svg

if [ -d ./web_font ]; then
	rm -rf ./web_font
fi

mkdir ./web_font

# copy all selectionned files from base folder
# to conv_tmp folder
find ./ -type f -name '*.'$pic_type -exec cp {} ./conv_tmp/ \;

# convert gif into svg
find ./ -type f -name '*.'$pic_type | xargs -I % basename % .$pic_type | xargs -I % convert ./conv_tmp/%.$pic_type ./conv_tmp/%.pnm
find ./ -type f -name '*.'$pic_type | xargs -I % basename % .$pic_type | xargs -I % potrace -s -o ./conv_tmp_svg/%.svg ./conv_tmp/%.pnm

# if rosetta_stone.txt is not empty
# we will convert file names
# but if it's empty ...
if [ ! -s ./rosetta_stone.txt ]; then
	mv ./conv_tmp_svg/* ./final_svg
	echo pouet
else
	# convert files names if needed
	while read line; do
		init=`echo $line | cut -d'|' -f1`
		new=`echo $line | cut -d'|' -f2`
		if [ -f ./conv_tmp_svg/$init.svg ]; then
			mv ./conv_tmp_svg/$init.svg ./final_svg/$new.svg
		fi
	done <./rosetta_stone.txt

fi

# create the webfont
fontcustom compile -F -o ./web_font ./final_svg >/dev/null

# delete temporary folders
rm -rf ./conv_tmp
rm -rf ./conv_tmp_svg