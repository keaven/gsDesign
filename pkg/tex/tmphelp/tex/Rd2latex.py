#!/usr/bin/env python

# convert Rd files to tex files, so they can be included
# as part of the user manual

import sys, os



# gsDesign package help file
gsDesign_package_files = [
    "gsDesign-package",
    ]

# second set of gsDesign files
main_gs_design_files = [
    "gsDesign",
    "gsProbability",
    "plot.gsDesign",
    "gsCP",
    "gsBoundCP",
    "gsbound",
    ]

# third set of gsDesign files
bin_trial_files = [
    "normalGrid",
    "binomial",
    "nSurvival",
    ]

# spending function files
spendfun_files = [
    "spendingfunctions",
    "sfHSD",
    "sfpower",
    "sfexp",
    "sfLDPocock",
    "sfpoints",
    "sflogistic",
    "sfTDist",
    ]

# other files
other_files = [
    "Wang-Tsiatis-bounds",
    "testutils",
    ]

all_files = gsDesign_package_files + main_gs_design_files + bin_trial_files + spendfun_files + other_files


# Make temporary directories to hold the Rd and tex files
#os.system("mkdir ./tmphelp")
#os.system("mkdir ./tmphelp/Rd")
#os.system("mkdir ./tmphelp/tex")

# source paths for all the help files
gsDesign_man_path = "../man/"

Rd_ext = ".Rd"
latex_ext = ".tex"
src_path = "./tmphelp/Rd/"
dest_path = "./tmphelp/tex/"
cmd = "R CMD Rdconv --type=latex "
output_files = ["gsDesign_package", "gsDesign_main", "bin_trial", "spending_functions", "other"] 

# copy all the source files from their SVN directory to the tmp .Rd dir
for file_name in all_files:
    cp_cmd = "cp " + gsDesign_man_path + file_name + Rd_ext + " " + src_path + file_name + Rd_ext
    os.system(cp_cmd)    


# convert Rd to tex
for file_name in all_files:
    exec_cmd = cmd + src_path + file_name + Rd_ext + " " + "-o " + dest_path + file_name + latex_ext
    os.system(exec_cmd)
                       

# check to see all tex files are generated
for file_name in all_files:
    if not os.path.exists(dest_path + file_name + latex_ext):
        print "ERROR: " + dest_path + file_name + latex_ext + " was not created"
        sys.exit(1)
        

# construct all tex files into five main tex files based on their classification
for out_file in output_files:
    f = file(out_file + "_doc.tex", 'w')

    if out_file=="gsDesign_package":
        content = "\section{Function and Class Reference}\n" + "\subsection{gsDesign Package}\n"
        for f_name in gsDesign_package_files:
            content = content + "\input{" + dest_path + f_name + "}\n"
    elif out_file=="gsDesign_main":
        content = "\subsection{gsDesign main functions}"
        for f_name in main_gs_design_files:
            content = content + "\input{" + dest_path + f_name + "}\n"
    elif out_file=="bin_trial":
        content = "\subsection{Binomial trial functions}"
        for f_name in bin_trial_files:
            content = content + "\input{" + dest_path + f_name + "}\n"
    elif out_file=="spending_functions":
        content = "\subsection{Spending Functions}"
        for f_name in spendfun_files:
            content = content + "\input{" + dest_path + f_name + "}\n"
    elif out_file=="other":
        content = "\subsection{Other Files}"
        for f_name in other_files:
            content = content + "\input{" + dest_path + f_name + "}\n"
    else:
        print "ERROR: file " + out_file + " is not specified"
        exit(1)
    
    f.write(content)
    f.close() # close file
    

