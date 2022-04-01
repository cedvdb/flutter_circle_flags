#!/bin/bash

# this program crashes and needs to be relaunched until every country is created
if test -e $PWD/png; then
    echo "png folder exists."
else
    echo "creating png folder "
    mkdir "$PWD"/png

fi

echo 'warning: AC TA AND BQ must be renamed from sh-ac, sh-ta, bq-bo'

for file in $PWD/svg/*.svg
    do

        filename=$(basename "$file" | cut -d. -f1)
        if test -f "$PWD/png/$filename.png"; then
            echo "$filename exists."
        else
            echo "creating $filename "
            inkscape "$file" --export-type=png --export-filename="$PWD"/png/"${filename%}.png" -w 128
        fi
    done

echo 'all done';
echo 'warning: AC TA AND BQ must be renamed from sh-ac, sh-ta, bq-bo'
