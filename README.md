# 3D Printing-Axis Estimator

![representative](https://github.com/trikbee/3DPAEstimator/blob/master/mesh%20thickness.PNG)

## Introduction
Source code for estimating printing-axis of 3D printed-and-scanned model. This work is based on our paper, "Blind 3D Mesh Watermarking for 3D Printed Model by Analyzing Layering Artifact." Using surface projection, filtering and frequency analysis, the proposed scheme estimates the printing direction of the printed model.

Algorithm details can be found in [here](https://ieeexplore.ieee.org/document/7954665)

## Dependencies
Requirements: 
- Matlab 2014b
- [Mesh Thickness Calculator](https://github.com/whahnize/MESH-THK)

## Usage
1. compile mex (mesh_thk_mex.h) from [Mesh Thickness Calculator](https://github.com/whahnize/MESH-THK)
2. run p_axis_est.m 


## Citation
If you find our work useful in your research, please consider citing:

      @article{hou2017blind,
        title={Blind 3D Mesh Watermarking for 3D Printed Model by Analyzing Layering Artifact},
        author={Hou, Jong-Uk and Kim, Do-Gon and Lee, Heung-Kyu},
        journal={IEEE Transactions on Information Forensics and Security},
        volume={12},
        number={11},
        pages={2712--2725},
        year={2017},
        publisher={IEEE}
      }
