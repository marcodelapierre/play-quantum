#!/bin/bash -l
#SBATCH --job-name=install-pennylane-source-cuda-topaz
#SBATCH --account=pawsey0001
#SBATCH --partition=gpu-dev
#SBATCH --exclusive
#SBATCH --ntasks=1
#SBATCH --threads-per-core=1
#SBATCH --gpus-per-node=8
#SBATCH --time=00:30:00
#SBATCH --output=out-%x

. use-pennylane-source-cuda-topaz.sh

# install from source
git clone https://github.com/PennyLaneAI/pennylane-lightning-gpu $source_dir/pennylane-lightning-gpu
cd $source_dir/pennylane-lightning-gpu
git checkout v$pl_ver

pip install --prefix=$install_dir nvidia-cuda-runtime-cu11 nvidia-cublas-cu11 nvidia-cusolver-cu11 nvidia-cusparse-cu11 cuquantum-cu11

cmake -B build . \
  -DCMAKE_BUILD_TYPE=Release \
  -DPLLGPU_ENABLE_MPI=on \
  -DCUQUANTUM_SDK="$install_dir/lib/python${python_ver}/site-packages/cuquantum"
cmake --build build --verbose
#   -DENABLE_CLANG_TIDY=on \

python setup.py build_ext \
  --define="PLLGPU_ENABLE_MPI=ON" \
  --cuquantum="$install_dir/lib/python${python_ver}/site-packages/cuquantum"
#python setup.py bdist_wheel
#pip install --prefix=$install_dir dist/PennyLane_Lightning_GPU-*.whl

pip install --prefix=$install_dir .
cd -