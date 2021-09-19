# Gaussian-Mixture-Model-algorithm-VHDL
Many applications in computer vision need to detect moving object in each frame as the first step of
processing. Therefore, one of the basics operations is the separation of moving objects called
foreground from the static scene called background. The process mainly used is background subtraction
[1]. In this process each input frame is compared to a background model (created with one or more
reference frames) to determine which pixels belong to the background and which pixels belong to the foreground. 
For this reason, it also is referred as foreground detection. 

![](https://github.com/taboML/Gaussian-Mixture-Model-algorithm-VHDL/blob/main/imgs/background_sub.png)

# Guassian Mixture Model algorithm
Within background subtraction, one of most used algorithms is the Gaussian Mixture Model algorithm
(GMM algorithm) [2]. With GMM algorithm, each pixel in the scene is modeled as a mixture of
Gaussian distributions. The Gaussian distributions of each pixel are used to evaluate if a new pixel will
be classified as foreground or background.<br />
Despite of the robustness that GMM algorithm offers, it is an algorithm that demands high computing
resources and, due to background subtraction is a task involved in several video processing systems, 
it has been proposed mapping the algorithm to hardware to obtain better performance both computing
speed and power consumption.<br />
Mariangela Genovese and Ettore Napoli proposed a hardware architecture which performs background
subtraction [3]. Their proposed hardware architecture implements the Gaussian Mixture Model
algorithm due to its advantages respect to other algorithms. This work has been taken as reference
to propose a hardware architecture that performs background subtraction correctly and, at the same
time, to have a good reference point. 

<p align="center">
  <img src="https://github.com/taboML/Gaussian-Mixture-Model-algorithm-VHDL/blob/main/imgs/block_diagram.png" />
</p>

To test this project just make a testbench for GMM_circuit.vhd file


# References
[1] Kumar, S., & Yadav, J. S. (2017). Background Subtraction Method for Object Detection and
    Tracking. In Proceeding of international conference on intelligent communication, control and
    devices (pp. 1057-1063). Springer, Singapore.<br />
[2] C. Stauffer and E. Grimson. Adaptive background mixture models for real-time tracking. IEEE
    Conference on Computer Vision and Pattern Recognition, CVPR, pages 246–252, 1999. <br />
[3] Genovese, M., & Napoli, E. (2013). ASIC and FPGA implementation of the Gaussian mixture 
    model algorithm for real-time segmentation of high definition video. IEEE transactions on very
    large scale integration (VLSI) systems, 22(3), 537-547.
