[![Covrpage Summary](https://img.shields.io/badge/covrpage-Last_Build_2019_01_17-brightgreen.svg)](http://tinyurl.com/y6uylrcw)

# gsDesign 

The gsDesign package supports group sequential clinical trial design.

While there is a strong focus on designs using **α** and **β** spending functions, Wang-Tsiatis designs, including O'Brien-Fleming and Pocock designs, are also available. The ability to design with non-binding futility rules allows control of Type I error in a manner acceptable to regulatory authorities when futility bounds are employed. Particular effort has gone into designs with time-to-event endpoints.

Most routines are designed to provide simple access to commonly used designs using default arguments. Standard, published spending functions are supported as well as the ability to write custom spending functions. A plot function provides a wide variety of plots summarizing designs: boundaries, power, estimated treatment effect at boundaries, conditional power at boundaries, spending function plots, expected sample size plot, and B-values at boundaries.

While the main design functions, ```gsDesign()``` and ```gsSurv()``` have a complex output, the function ```gsBoundSummary()``` provides a simple summary of a design in a data frame that can be useful for printing in a document.

Thus, the intent of the gsDesign package is to easily create, fully characterize and even optimize routine group sequential trial designs as well as provide a tool to evaluate innovative designs.