find ~/Library/Developer/Xcode/DerivedData \
      -name "' + library_name + '.doccarchive" \
      -exec rm -Rf {} \; || true