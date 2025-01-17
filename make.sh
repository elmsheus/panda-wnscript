#!/bin/bash

WORKDIR=$PWD
SRCDIR=$WORKDIR/src
DISTDIR=$WORKDIR/dist
BUILDDIR=$WORKDIR/build
TEMPLATEDIR=$WORKDIR/template

TMPZIP=$BUILDDIR/tmp.zip

# initial cleanup
mkdir -p $DISTDIR
mkdir -p $BUILDDIR
rm -rf $DISTDIR/*
rm -rf $BUILDDIR/*

# loop over all target
# already in the old directory: "buildGen" "runAthena" "buildJob"
for TARGET in "runGen"
  do
  echo "Start " $TARGET  
  EXESRCDIR=$SRCDIR/`echo $TARGET | tr "[A-Z]" "[a-z]"`
  EXENAME=$DISTDIR/$TARGET-`cat $EXESRCDIR/version`
  rm -f $TMPZIP
  # include utils
  zip -o $TMPZIP -R pandawnutil "*.py" "*.c"
  # script main
  cd $EXESRCDIR
  zip -o $TMPZIP -R . "*.py"
  cd $WORKDIR
  # make self-exracting executable
  cat $TEMPLATEDIR/zipheader $TMPZIP > $EXENAME
  chmod +x $EXENAME
  echo
done

# with CVMFS
for TARGET in "preEvtPick" "preGoodRunList"
  do
  echo "Start " $TARGET  
  EXESRCDIR=$SRCDIR/`echo $TARGET | tr "[A-Z]" "[a-z]"`
  EXENAME=$DISTDIR/$TARGET-`cat $EXESRCDIR/version`
  rm -f $TMPZIP
  # include utils
  zip -o $TMPZIP -r pandawnutil -i "*.py" "*.c"
  # script main
  cd $EXESRCDIR
  zip -o $TMPZIP -r . -i "*.py" "panda-wn_ext_apps"
  cd $WORKDIR
  # make self-exracting executable
  cat $TEMPLATEDIR/zipheaderCVMFS $TMPZIP > $EXENAME
  chmod +x $EXENAME
  echo
done

# include non-python files
for TARGET in "runMerge"
  do
  echo "Start " $TARGET  
  EXESRCDIR=$SRCDIR/`echo $TARGET | tr "[A-Z]" "[a-z]"`
  EXENAME=$DISTDIR/$TARGET-`cat $EXESRCDIR/version`
  rm -f $TMPZIP
  # include utils
  zip -o $TMPZIP -r pandawnutil -i "*.py" "*.c"
  # script main
  cd $EXESRCDIR
  zip -o $TMPZIP -r . -i *
  cd $WORKDIR
  # make self-exracting executable
  cat $TEMPLATEDIR/zipheader $TMPZIP > $EXENAME
  chmod +x $EXENAME
  echo
done
