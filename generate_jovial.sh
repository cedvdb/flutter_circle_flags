#!/bin/sh

# Ensure ./assets/jovial exists
if [ ! -d "./assets/jovial" ]; then
    mkdir ./assets/jovial
fi

# Loop through all the files in the svg folder
for file in ./assets/svg/*.svg
do
  # Get the filename without the extension
  filename=$(basename -- "$file")
  filename="${filename%.*}"
  jovial_filename="${filename}.si"
  # Check if jovial file already exists
  if [ ! -f "./assets/jovial/$jovial_filename" ]; then
    # Generate the jovial file
    echo "Generating: $jovial_filename"
    # run the flutter pub run jovial_svg:svg_to_si command for each file
    flutter pub run jovial_svg:svg_to_si "$file" --out ./assets/jovial/
  else
    echo "Already exists: $jovial_filename"
  fi
done