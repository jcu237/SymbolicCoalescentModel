needs "./SCM/SCM.m2"

R = QQ[x_1..x_8,t_1..t_2]

N = digraph {
    {-1,0},{-1,1},{0,2},{0,3},{2,3},{2,4},{3,5},{4,5},
    {3,"A"},{5,"B"},{4,"C"},{1,"D"},{1,"E"}
}

edgeHash = new HashTable from {
    {-1,0} => x_1,
    {-1,1} => x_8,
    {0,2} => x_2,
    {0,3} => x_3,
    {2,3} => x_4,
    {2,4} => x_6,
    {3,5} => x_5,
    {4,5} => x_7
};

hybridHash = new HashTable from {
    3 => t_1,
    5 => t_2
};

geneTrees = getGeneTrees 5;

time geneTreeProbs = apply(geneTrees, T -> makeProb(N,T,edgeHash,hybridHash));

numericEdgeHash = new HashTable from {
    {-1,1} => .96519769758919227p53, 
    {4,5} => .23613084891738334p53,
    {3,5} => .66139085285649923p53, 
    {0,2} => .67466553921870009p53, 
    {0,3} =>.2397030391783328p53, 
    {2,3} => .90713465392049686p53, 
    {2,4} => .71421536972873079p53,
    {-1,0} => .24855881942367719p53
}


numericHybridHash = new HashTable from {
    5 => .95900755443975438p53, 
    3 => .65965533430939538p53
}

time geneTreeProbsNumeric = apply(geneTrees, T -> makeProb(N,T,numericEdgeHash,numericHybridHash))



