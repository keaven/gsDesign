# test: Checking LaTeX output for gsSurv

    \begin{table}[ht]
    \centering
    \begin{tabular}{llll}
      \hline
    Analysis & Value & Futility & Efficacy \\ 
      \hline
    IA 1: 25$\backslash$\% & Z-value & 0.23 & 3.16 \\ 
      N: 82 & HR & 0.92 & 0.31 \\ 
      Events: 29 & p (1-sided) & 0.4105 & 8e-04 \\ 
      12.2 months & P$\backslash$\{Cross$\backslash$\} if HR=1 & 0.5895 & 8e-04 \\ 
        & P$\backslash$\{Cross$\backslash$\} if HR=0.5 & 0.05 & 0.0995 \\ 
       \hline
    $\backslash$hline IA 2: 50$\backslash$\% & Z-value & 0.86 & 2.82 \\ 
      N: 128 & HR & 0.8 & 0.48 \\ 
      Events: 58 & p (1-sided) & 0.1944 & 0.0024 \\ 
      19 months & P$\backslash$\{Cross$\backslash$\} if HR=1 & 0.8366 & 0.003 \\ 
        & P$\backslash$\{Cross$\backslash$\} if HR=0.5 & 0.0707 & 0.4388 \\ 
       \hline
    $\backslash$hline IA 3: 75$\backslash$\% & Z-value & 1.46 & 2.44 \\ 
      N: 160 & HR & 0.73 & 0.59 \\ 
      Events: 87 & p (1-sided) & 0.0723 & 0.0074 \\ 
      25 months & P$\backslash$\{Cross$\backslash$\} if HR=1 & 0.9445 & 0.0085 \\ 
        & P$\backslash$\{Cross$\backslash$\} if HR=0.5 & 0.0866 & 0.7776 \\ 
       \hline
    $\backslash$hline Final analysis & Z-value & 2.01 & 2.01 \\ 
      N: 160 & HR & 0.69 & 0.69 \\ 
      Events: 116 & p (1-sided) & 0.022 & 0.022 \\ 
      36 months & P$\backslash$\{Cross$\backslash$\} if HR=1 & 0.9813 & 0.0187 \\ 
        & P$\backslash$\{Cross$\backslash$\} if HR=0.5 & 0.1 & 0.9 \\ 
       \hline
    \end{tabular}
    \end{table}

# test: Checking LaTeX output for gsSurv for footnote not NULL

    \begin{table}[ht]
    \centering
    \begin{tabular}{llll}
      \hline
    Analysis & Value & Futility & Efficacy \\ 
      \hline
    IA 1: 25$\backslash$\% & Z-value & 0.23 & 3.16 \\ 
      N: 82 & HR & 0.92 & 0.31 \\ 
      Events: 29 & p (1-sided) & 0.4105 & 8e-04 \\ 
      12.2 months & P$\backslash$\{Cross$\backslash$\} if HR=1 & 0.5895 & 8e-04 \\ 
        & P$\backslash$\{Cross$\backslash$\} if HR=0.5 & 0.05 & 0.0995 \\ 
       \hline
    $\backslash$hline IA 2: 50$\backslash$\% & Z-value & 0.86 & 2.82 \\ 
      N: 128 & HR & 0.8 & 0.48 \\ 
      Events: 58 & p (1-sided) & 0.1944 & 0.0024 \\ 
      19 months & P$\backslash$\{Cross$\backslash$\} if HR=1 & 0.8366 & 0.003 \\ 
        & P$\backslash$\{Cross$\backslash$\} if HR=0.5 & 0.0707 & 0.4388 \\ 
       \hline
    $\backslash$hline IA 3: 75$\backslash$\% & Z-value & 1.46 & 2.44 \\ 
      N: 160 & HR & 0.73 & 0.59 \\ 
      Events: 87 & p (1-sided) & 0.0723 & 0.0074 \\ 
      25 months & P$\backslash$\{Cross$\backslash$\} if HR=1 & 0.9445 & 0.0085 \\ 
        & P$\backslash$\{Cross$\backslash$\} if HR=0.5 & 0.0866 & 0.7776 \\ 
       \hline
    $\backslash$hline Final analysis & Z-value & 2.01 & 2.01 \\ 
      N: 160 & HR & 0.69 & 0.69 \\ 
      Events: 116 & p (1-sided) & 0.022 & 0.022 \\ 
      36 months & P$\backslash$\{Cross$\backslash$\} if HR=1 & 0.9813 & 0.0187 \\ 
        & P$\backslash$\{Cross$\backslash$\} if HR=0.5 & 0.1 & 0.9 $\backslash$$\backslash$ $\backslash$hline $\backslash$multicolumn\{4\}\{p\{ 9cm \}\}\{$\backslash$footnotesize This is a footnote; note that it can be wide. \} \\ 
       \hline
    \end{tabular}
    \caption{Caption example.} 
    \end{table}

# Check LaTeX output for gsSurv for testtype = 1

    \begin{table}[ht]
    \centering
    \begin{tabular}{lll}
      \hline
    Analysis & Value & Efficacy \\ 
      \hline
    IA 1: 25$\backslash$\% & Z-value & 3.16 \\ 
      N: 64 & HR & 0.26 \\ 
      Events: 23 & p (1-sided) & 8e-04 \\ 
      12.2 months & P$\backslash$\{Cross$\backslash$\} if HR=1 & 8e-04 \\ 
        & P$\backslash$\{Cross$\backslash$\} if HR=0.5 & 0.0644 \\ 
       \hline
    $\backslash$hline IA 2: 50$\backslash$\% & Z-value & 2.82 \\ 
      N: 98 & HR & 0.43 \\ 
      Events: 45 & p (1-sided) & 0.0024 \\ 
      19 months & P$\backslash$\{Cross$\backslash$\} if HR=1 & 0.003 \\ 
        & P$\backslash$\{Cross$\backslash$\} if HR=0.5 & 0.3151 \\ 
       \hline
    $\backslash$hline IA 3: 75$\backslash$\% & Z-value & 2.44 \\ 
      N: 124 & HR & 0.55 \\ 
      Events: 67 & p (1-sided) & 0.0074 \\ 
      25 months & P$\backslash$\{Cross$\backslash$\} if HR=1 & 0.0089 \\ 
        & P$\backslash$\{Cross$\backslash$\} if HR=0.5 & 0.6631 \\ 
       \hline
    $\backslash$hline Final analysis & Z-value & 2.01 \\ 
      N: 124 & HR & 0.65 \\ 
      Events: 89 & p (1-sided) & 0.022 \\ 
      36 months & P$\backslash$\{Cross$\backslash$\} if HR=1 & 0.025 \\ 
        & P$\backslash$\{Cross$\backslash$\} if HR=0.5 & 0.9 $\backslash$$\backslash$ $\backslash$hline $\backslash$multicolumn\{4\}\{p\{ 9cm \}\}\{$\backslash$footnotesize This is a footnote; note that it can be wide. \} \\ 
       \hline
    \end{tabular}
    \caption{Caption example.} 
    \end{table}

