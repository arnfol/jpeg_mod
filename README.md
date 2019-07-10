# Welcome to JPEG modification project repository

This repository is a part of JPEG modification project. It contains RTL code for HDMI converters, DCT & IDCT and multiplier & divider modules for quantisation. 

![general view]()

For simulation we used Modelsim PE 10.4a, you can find .tcl scripts for it in the corresponding folders, in **./sim/** subfolders. 

## Data flow descriprion

The pictures bellow describe pixel order in the data flow of the system.

![data flow of coder]()
![data flow of decoder]()

## DCT 
 
We use the BinDCT - fast implementation without multipliers. The description of the algorithm can be found in articles:
[links]()

## Synthesis results
The whole system was synthesised in Quartus II for Arria V family. You can find the project in the **./quartus** folder.

|                    | Balanced mode | Perfomance high effort mode |
| ------------------ | ------------- | --------------------------- |
| Max frequency, MHz | 158           | 165                         |
| ALMs               | 10,887        | 10,910                      |
| Block memory, bits | 1,676,100     | 1,676,100                   |
| DSPs               | 8             | 8                           |

## Useful links
[links from wiki]()