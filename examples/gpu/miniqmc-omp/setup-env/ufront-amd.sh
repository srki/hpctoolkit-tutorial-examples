# load modules needed to build and run miniqmc
module use /projects/modulefiles
module use /usr/local/modules
module load rocm/5.4.3 #cmake
spack load openblas cmake

# modules for hpctoolkit
export HPCTOOLKIT_MODULES_HPCTOOLKIT="module load hpctoolkit/2023.08.1"
$HPCTOOLKIT_MODULES_HPCTOOLKIT

# environment settings for this example
export HPCTOOLKIT_GPU_PLATFORM=amd
export HPCTOOLKIT_MINIQMC_MODULES_BUILD=""
export HPCTOOLKIT_MINIQMC_GPUFLAGS="-DENABLE_OFFLOAD=1 -DOFFLOAD_TARGET=amdgcn-amd-amdhsa -DOFFLOAD_ARCH=gfx90a -DQMC_MIXED_PRECISION=ON"
export HPCTOOLKIT_MINIQMC_CXX_COMPILER=amdclang++
export HPCTOOLKIT_MINIQMC_SUBMIT="sh"
export HPCTOOLKIT_MINIQMC_RUN="env ROCR_VISIBLE_DEVICES=1,2 sh"
export HPCTOOLKIT_MINIQMC_RUN_PC="sh make-scripts/unsupported-amd.sh"
export HPCTOOLKIT_MINIQMC_BUILD="sh"
export HPCTOOLKIT_MINIQMC_LAUNCH="sh"

# mark configuration for this example
export HPCTOOLKIT_EXAMPLE=miniqmc
