#!/usr/bin/env bash

set -o errexit -o xtrace

# r-rgl needs libGL.so.1 provided by the system package manager
#apt-get -y install libgl1 libgomp1

tee ${MAMBA_ROOT_PREFIX}/condarc << EOF
channels:
  - dnachun
  - conda-forge
  - bioconda
  - nodefaults
EOF

tee ${PIXI_HOME}/envs/python/lib/python3.12/site-packages/sitecustomize.py << EOF
import sys
sys.path[0:0] = [
    "${MAMBA_ROOT_PREFIX}/envs/python_libs/lib/python3.12/site-packages"
]
EOF

ln -f ${PIXI_HOME}/envs/python/lib/python3.12/site-packages/sitecustomize.py ${PIXI_HOME}/envs/jupyter_client/lib/python3.12/site-packages/
ln -f ${PIXI_HOME}/envs/python/lib/python3.12/site-packages/sitecustomize.py ${PIXI_HOME}/envs/jupyter_core/lib/python3.12/site-packages/
ln -f ${PIXI_HOME}/envs/python/lib/python3.12/site-packages/sitecustomize.py ${PIXI_HOME}/envs/jupyter_server/lib/python3.12/site-packages/
ln -f ${PIXI_HOME}/envs/python/lib/python3.12/site-packages/sitecustomize.py ${PIXI_HOME}/envs/jupyterlab/lib/python3.12/site-packages/
ln -f ${PIXI_HOME}/envs/python/lib/python3.12/site-packages/sitecustomize.py ${PIXI_HOME}/envs/sos/lib/python3.12/site-packages/

mkdir -p ${PIXI_HOME}/envs/r-base/lib/R/etc
echo ".libPaths('${MAMBA_ROOT_PREFIX}/envs/r_libs/lib/R/library')" >> ${PIXI_HOME}/envs/r-base/lib/R/etc/Rprofile.site

# pixi global currently gives it wrappers all lowercase names, so we need to make symlinks for R and Rscript
ln -sf ${PIXI_HOME}/bin/r ${PIXI_HOME}/bin/R
ln -sf ${PIXI_HOME}/bin/rscript ${PIXI_HOME}/bin/Rscript

# pixi global mistakenly points the samtools wrapper to samtools.pl, so we need to revert this change
if [ -f ${PIXI_HOME}/bin/samtools ]; then
    sed -i "s/samtools.pl/samtools/" ${PIXI_HOME}/bin/samtools
fi
