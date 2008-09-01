gsCredibility<-function(x)
{   pow<-x$upper$prob[,2]
    for (i in 2:x$k) pow[i]<-pow[i]+pow[i-1]
    if (x$test.type == 4 || x$test.type==6) alph<-x$falseposnb
    else alph<-x$upper$prob[,1]
    for (i in 2:x$k) alph[i]<-alph[i]+alph[i-1]
    return(pow/alph)
}
