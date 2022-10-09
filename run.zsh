#!/bin/zsh

SRC="${BUILD_DIR%Build/*}/SourcePackages/checkouts/ProductAnalytics"
cd $SRC
swift build
echo pwd
echo "Try to run: .build/x86_64-apple-macosx/${CONFIGURATION:lower}/ProductAnalytics"
.build/x86_64-apple-macosx/${CONFIGURATION:lower}/ProductAnalytics
