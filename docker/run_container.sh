#!/bin/sh
docker run -it --volume="$PWD/..:/workdir/bbb" bbb:imx-1
