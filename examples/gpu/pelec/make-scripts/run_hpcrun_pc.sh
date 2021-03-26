#!/bin/bash


${HPCTOOLKIT_PELEC_MODULES_BUILD}
${HPCTOOLKIT_PELEC_MODULES_HPCTOOLKIT}

BINARY=PeleC3d.gnu.CUDA.ex
DIR=PeleC/Exec/RegTests/PMF
EXEC=./${BINARY}
INPUT=./inputs_ex
OUT=hpctoolkit-${BINARY}-gpu-cuda-pc

cd ${DIR}

/bin/rm -rf ${OUT}.m ${OUT}.d

# measure an execution of PeleC
if [[ "${HPCTOOLKIT_TUTORIAL_GPU_PLATFORM}" == "summit" ]]
then
  echo "${HPCTOOLKIT_PELEC_LAUNCH} --smpiargs=\"-x PAMI_DISABLE_CUDA_HOOK=1 -disable_gpu_hooks\" \
    hpcrun -o $OUT.m -e gpu=nvidia,pc -t ${EXEC} ${INPUT}" 
  ${HPCTOOLKIT_PELEC_LAUNCH} --smpiargs="-x PAMI_DISABLE_CUDA_HOOK=1 -disable_gpu_hooks" \
    hpcrun -o $OUT.m -e gpu=nvidia,pc -t ${EXEC} ${INPUT}
else
  echo "${HPCTOOLKIT_PELEC_LAUNCH} hpcrun -o $OUT.m -e gpu=nvidia,pc -t ${EXEC} ${INPUT}"
  time  ${HPCTOOLKIT_PELEC_LAUNCH} hpcrun -o $OUT.m -e gpu=nvidia,pc -t ${EXEC} ${INPUT}
fi

# measure an execution of PeleC
echo "${HPCTOOLKIT_PELEC_LAUNCH} hpcrun -o $OUT.m -e gpu=nvidia,pc -t ${EXEC} ${INPUT}"
time  ${HPCTOOLKIT_PELEC_LAUNCH} hpcrun -o $OUT.m -e gpu=nvidia,pc -t ${EXEC} ${INPUT}

# compute program structure information for the PeleC binary
STRUCT_OUT=${BINARY}-pc.hpcstruct
STRUCT_PELEC="hpcstruct -j 16 -o ${STRUCT_OUT} ${EXEC}"
echo ${STRUCT_PELEC}
$STRUCT_PELEC

# compute program structure information for the PeleC cubins
STRUCT_CUBIN="hpcstruct -j 16 --gpucfg no $OUT.m" 
echo ${STRUCT_CUBIN}
${STRUCT_CUBIN}

# combine the measurements with the program structure information
ANALYZE="hpcprof -S ${STRUCT_OUT} -o $OUT.d $OUT.m"
echo $ANALYZE
${ANALYZE}

cd -

mv ${DIR}/$OUT.d ${DIR}/$OUT.m ./
