# load modules needed to build and run lammps
module use /projects/modulefiles
module use /usr/local/modules
module load gcc/11.4.0-nvptx cuda/12.2 openmpi/4.1.5/cuda-12.2.1 cmake

# modules for hpctoolkit
module use /home/johnmc/modulefiles
export HPCTOOLKIT_MODULES_HPCTOOLKIT="module load hpctoolkit/2023.08.1"
$HPCTOOLKIT_MODULES_HPCTOOLKIT

# environment settings for this example
export HPCTOOLKIT_GPU_PLATFORM=nvidia
export HPCTOOLKIT_LAMMPS_ROOT="$(pwd)"
export HPCTOOLKIT_LAMMPS_MODULES_BUILD=""
export HPCTOOLKIT_LAMMPS_GPU_ARCH="-DKokkos_ARCH_AMPERE80=ON"
export HPCTOOLKIT_LAMMPS_HOST_ARCH="-DKokkos_ARCH_ZEN2=ON"
export HPCTOOLKIT_LAMMPS_GPUFLAGS="-DKokkos_ENABLE_CUDA=yes -DCMAKE_CXX_COMPILER=$(pwd)/lammps/lammps/lib/kokkos/bin/nvcc_wrapper -DCMAKE_CXX_FLAGS=\"-lineinfo\""
export HPCTOOLKIT_LAMMPS_SUBMIT="sh"
export HPCTOOLKIT_LAMMPS_RUN="sh"
export HPCTOOLKIT_LAMMPS_RUN_PC="sh"
export HPCTOOLKIT_LAMMPS_BUILD="sh"
export HPCTOOLKIT_LAMMPS_OMP_NUM_THREADS=1
export HPCTOOLKIT_LAMMPS_LAUNCH="mpiexec -n 1"

# mark configuration for this example
export HPCTOOLKIT_EXAMPLE=lammps
