#!/bin/bash 

$HPCTOOLKIT_QS_MODULES_BUILD
$HPCTOOLKIT_MODULES_HPCTOOLKIT

BINARY=qs
EXEC=quicksilver/src/${BINARY}
OUT=hpctoolkit-${BINARY}-gpu-cuda

CMD="rm -rf ${OUT}.m ${OUT}.d $STRUCT_FILE"
echo $CMD
$CMD

# measure an execution of quicksilver
CMD="time ${HPCTOOLKIT_QS_LAUNCH} hpcrun -o $OUT.m -e REALTIME  -e gpu=nvidia -t ${EXEC}"
echo $CMD
$CMD

# compute program structure information for quicksilver CPU and GPU binaries
CMD="hpcstruct --gpucfg no $OUT.m" 
echo $CMD
$CMD

# combine measurement data with program structure information
CMD="hpcprof -o $OUT.d $OUT.m"
echo $CMD
$CMD

touch log.run.done
