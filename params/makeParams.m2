-- load in SCM.m2
needs "./../SCM/SCM.m2"

-- load in appropriate edge set
needs "./../graphs/fiveCycleGraphs.m2"

-- trim edge set as necessary
EE = delete(null, E5)

-- avoid triangles on cherries away from root (not always applicable)
-- avoidPatterns = {
--     {{4,5},{4,6},{5,6},{5,"D"},{6,"E"}} / set
-- }
-- EE = select(EE, E -> all(avoidPatterns, T -> isSubset(T, E / set) == false))

-- number of edges with weights
N = (#first EE) - 5

-- number of hybrid nodes
k = 1

-- get gene trees 
geneTrees = getGeneTrees 5

-- rings we will use
R = QQ[u_0..u_15]
S = QQ[x_0..x_N, t_1..t_k]


-- file to save everything in
file = "./fiveCycleParams.m2"

range = toList(0..#EE-1)

for i in range do (
    
    E := EE#i;
    network := digraph E;
    
    nonLeafEdges := select(E, e -> all(toList "ABCDE", a -> member(a,e) == false));
    edgeHash := new HashTable from apply(N, i -> nonLeafEdges#i => x_(i+1));
    

    hybrids := select(vertices network, v -> degreeIn(net, v) > 1);
    hybridHash := new HashTable from apply(k, i -> hybrids#i => t_(i+1));
    
    print(concatenate("computing network ", toString(i+1), " out of ", toString(#EE)));

    file << concatenate("im", toExternalString i, " = {\n");
    
    for j from 0 to 15 do (

        if j == 0 then (
            file << concatenate("\t", toExternalString(x_0), ",\n");
        ) else if j < 15 then (
            file << concatenate("\t", toExternalString(x_0 * makeProbability(network, geneTrees#(j-1), edgeHash, hybridHash)), ",\n");
        ) else (
            file << concatenate("\t", toExternalString(x_0 * makeProbability(network, geneTrees#(j-1), edgeHash, hybridHash)), "\n");
        );
    );
    
    file << "}\n";
    
    collectGarbage();
)

file << close

end

restart
needs "./makeParams.m2"


