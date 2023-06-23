git clone https://github.com/HatScripts/circle-flags.git
cd circle-flags/flags
# we don't need those
rm -rf fictional
rm -rf language
cd ../..
mv circle-flags/flags/* assets
# rm -rf circle-flags
# cd assets 
# convert-svg-to-png --height 128