# Reconstruction techniques for determining O/F in hybrid rockets
This repository contains Matlab (R2020a) code for determining fuel mass flow rate in hybrid rocket based on overall fuel mass consumption, chamber pressure history, and oxidizer flow mass flow rate history.

A .zip file has been added as "RT_20210716" for downloading convenience

## License
[MIT-License](https://github.com/HokudaiLSS/RT_20210716/blob/main/MIT%20License.txt)

## Code  
---

### Main program  
- P_main_RT.m  

### Functions  
- calculation_pressure_chamber_PRTM.m
- calculation_thrust_TRTEM.m
- equation_area_circle.m
- equation_coefficient_thrust.m
- equation_pressure_chamber.m
- equation_ratio_nozzleexpansion.m
- equation_residual.m
- equation_specificimplulse.m
- equation_thrust.m
- equation_velocity_characteristicexhaust.m
- equation_velocity_effectiveexhaust.m
- equation_velocity_exit.m
- integration_trapezoidal.m
- interpolation_linear.m
- interation_efficiency_combustion_OP_F_C.m
- interation_efficiency_combustion_OP_F_CE.m
- interation_efficiency_combustion_PRTEM.m
- interation_efficiency_thrust_TRREM.m
- interation_massflowrate_fuel_PRTM.m
- interation_massflowrate_fuel_TRTEM.m
- interation_pressure_exit.m

#### Data organization  
- task_sort_fieldname.m


#### Mapping
- F_SaveFig.m
- F_make_graph.m  
	- F_make_graph_CEA.m  
	- F_make_graph_CEA_double.m
	- F_make_graph_compare.m
	- F_make_graph_compare_eta.m
	- F_make_graph_input.m
	- F_make_graph_input_all.m
	- F_make_graph_output_OP_F_C.m
	- F_make_graph_output_PRTM.m
	- F_make_graph_output_TPTEM.m

      
## How to cite
If you use the Reconstruction Technique Algorithm code in your work, please cite the software itself and relevent paper.
### General software reference:
```bibtex
@misc{saito2021github,
      author = {Saito, Y., and Kamps, L},
      title = {Reconstruction techniques for determining O/F in hybrid rockets},
      howpublished = {Available online},
      year = {2021},
      url = {https://github.com/HokudaiLSS/RT_20210716}
}
```
### Relevent paper reference:
```bibtex
@inproceedings{saito2021reconstruction,
  title={Reconstruction techniques for determining O/F in hybrid rockets},
  author={Saito, Yuji and Kamps, Landon T and Tsuji, Ayumu and Nagata, Harunori},
  booktitle={AIAA Propulsion and Energy 2021 Forum},
  pages={3499},
  year={2021}
}
```
## Author
SAITO Yuji, KAMPS Landon

[Laboratory of Space Systems](https://mech-hm.eng.hokudai.ac.jp/~spacesystem/)
Hokkaido University, Sapporo, JAPAN

E-mail: kamps@eng.hokudai.ac.jp, yuji.saito@tohoku.ac.jp
