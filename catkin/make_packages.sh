#!/bin/bash -ex


TOP=$(pwd)
BUILD=$TOP/pkgbuild
export ROS_DISTRO=electric
CMAKE="cmake \
  -DCMAKE_INSTALL_PREFIX=/opt/ros/$ROS_DISTRO \
  -DCMAKE_PREFIX_PATH=/opt/ros/$ROS_DISTRO \
  -DCATKIN_PACKAGE_PREFIX=ros-$ROS_DISTRO- \
  -DCATKIN_DEB_SNAPSHOTS=YES
"

CATKIN_DEB_SNAPSHOT_VERSION=$(date +%Y%m%d-%H%M%z)
export CATKIN_DEB_SNAPSHOT_VERSION

rm -rf $BUILD
mkdir -p $BUILD
cd $BUILD

fatbuild ()
{
    mkdir $BUILD/buildall
    pushd $BUILD/buildall
    $CMAKE '-DCATKIN_DPKG_BUILDPACKAGE_FLAGS=-d;-S;-k28B6AB2C' $TOP/OpenCV
    for distro in lucid maverick natty oneiric
    do
        make VERBOSE=1 CATKIN_DEB_SNAPSHOT_VERSION=$CATKIN_DEB_SNAPSHOT_VERSION CATKIN_DEBIAN_DISTRIBUTION=$distro gendebian
    done
    popd
}

fatbuild
