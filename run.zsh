#!/bin/zsh

SRC="${BUILD_DIR%Build/*}/SourcePackages/checkouts/ProductAnalytics"
cd $SRC
swift build
  .build/x86_64-apple-macosx/${CONFIGURATION:lower}/ProductAnalytics
