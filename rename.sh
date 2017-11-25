LIST=(`ls *.onion* | cut -d"(" -f1`)
for i in `seq 0 ${#LIST[@]}`; do mv -v "${LIST[$i]}"* "${LIST[$i]}.pdf"; done;
