# Spending function overview

## Introduction

Spending functions are used to set boundaries for group sequential
designs. Using the spending function approach to design offers a natural
way to provide interim testing boundaries when unplanned interim
analyses are added or when the timing of an interim analysis changes.
Many standard and investigational spending functions are provided in the
gsDesign package. These offer a great deal of flexibility in setting up
stopping boundaries for a design.

Spending functions have three arguments and return an object of type
`spendfn`. The [`summary()`](https://rdrr.io/r/base/summary.html)
function for `spendfn` objects provides a brief textual summary of a
spending function or boundary used for a design. Normally a spending
function will be passed to
[`gsDesign()`](https://keaven.github.io/gsDesign/reference/gsDesign.md)
in the parameter `sfu` for the upper bound and `sfl` for the lower bound
to specify a spending function family for a design. In this case, the
user does not need to know the calling sequence — only how to specify
the parameter(s) for the spending function. The calling sequence is
useful when the user wishes to plot a spending function as demonstrated
below in examples. In addition to using supplied spending functions, a
user can write code for a spending function. See examples.

## Examples

See
[`spendingFunction()`](https://keaven.github.io/gsDesign/reference/spendingFunction.md)
for the input and output specification of spending functions. It also
contains two code examples showing how to use an implemented spending
function and create new spending functions. For more detailed examples,
see the [spending
functions](https://keaven.github.io/gsd-tech-manual/spendfn.html)
chapter in the gsDesign technical manual.

## References

Jennison, Christopher, and Bruce W. Turnbull. 2000. *Group Sequential
Methods with Applications to Clinical Trials*. Boca Raton, FL: Chapman;
Hall/CRC.
