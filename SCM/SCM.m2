needsPackage "Graphs"

needs "./miscGraphFunctions.m2"
needs "./updateGraphs.m2"
needs "./updateHashTables.m2"


-- Input: taxa incoming to edge and an undirected tree
-- Output: a list of all rooted forests that could have arisen given the gene tree
possibleCoalescentsInternalEdge = (taxaBelow, geneTree) -> (

    -- make sure that taxa below are leaves of the gene tree
    if isSubset(taxaBelow, leaves geneTree) == false then error("incompatible taxa and gene tree");

    -- we find all rooted binary forests on taxaBelow compatibale with geneTree
    rootedForests := {};

    -- a forest is compatible with geneTree if it is a subgraph of some rooting of geneTree
    -- so, we loop over all edges of geneTree and place a root in the middle of this edge
    for e in edges geneTree do (

        -- T = geneTree rooted along e
        T := rootTreeFromEdge(geneTree, e);

        -- internal nodes are potential roots in the forest
        internalNodes := select(vertices T, v -> degreeOut(T,v) > 0);

        -- loop over non-empty subsets of internalNodes
        for V in delete({}, subsets(internalNodes)) do (
            
            -- F = subforest induced by taking all descendants of v \in V
            F := getSubForest(T, V);
            leavesF := getLeavesOfDigraph F;

            -- only look at forests that are coalescing things in taxaBelow
            if isSubset(leavesF, taxaBelow) then (
                
                -- add in singletons from taxaBelow if they are not already in F
                missingLeaves := select(taxaBelow, leaf -> member(leaf, vertices F) == false);
                FF := digraph(missingLeaves | vertices F, edges F);

                -- if this forest is not already in rootedForests, then add it to the list
                if any(rootedForests, G -> G == FF) == false then (

                    rootedForests = rootedForests | {FF};
                );
            );
        );
    );

    -- add in the no coalescence event
    rootedForests = rootedForests | {digraph(taxaBelow, {})};

    return rootedForests
)


-- g_{ij}(v) = probability of i taxa coalescing to j taxa in an edge of length v (in coalescent units)
gTavare = (i,j,v) -> (
    
    if i < j then (
        return 0;
    );

    return sum for k from j to i list (
        coeff1 := (2*k-1) * (-1)^(k-j) / ((j!) * ((k-j)!) * (j+k-1));
        coeff2 := product apply(k, m -> (j+m) * (i-m) / (i+m));
        v^(binomial(k,2)) * coeff1 * coeff2
    );
)

-- Input: a rooted tree
-- Output: the number of coalescent histories yielding T
buildOrdersTree = T -> (

    Leafs := select(vertices T, v -> #children(T,v)==0);
    internalNodes := select(vertices T, v -> #children(T,v)>0);
    H := product apply(internalNodes, v -> #(descendants(T,v) * set internalNodes));
    
    return (#internalNodes)! / H
)

-- Input: a rooted forest
-- Output: the number of coalescent histories yielding the forest
buildOrdersForest = forest -> (

    internalNodes := select(vertices forest, v -> #children(forest,v)>0);
    graphF := graph(vertices forest, edges forest);
    comps := connectedComponents graphF;

    L := for c in comps list (
        
        T := digraph(c, select(edges forest, e -> isSubset(e,c)));
        mc := #select(vertices T, v -> member(v, internalNodes));
        Fc := buildOrdersTree(T);
        {mc,Fc}
    );

    return multinomial(#internalNodes, apply(L, i -> first i)) * product(L, i -> last i)
)



probOfForestInEdge = (F, e, edgeHash) -> (
    
    cF := buildOrdersForest F;
    i := #select(vertices F, v -> degreeOut(F,v) == 0);
    j := #select(vertices F, v -> degreeIn(F,v) == 0);
    totalBuilds := product(j+1..i, k -> binomial(k,2));

    return (cF / totalBuilds) * gTavare(i,j,edgeHash#e)
)




makeProb = method(TypicalValue => RingElement)
makeProb(Digraph, Graph, HashTable, HashTable) := (speciesNetwork, geneTree, edgeHash, hybridHash) -> (
    
    -- prune species network, in case leaves(geneTree) is strictly smaller than leaves(speciesNetwork)
    N := updateNetwork(speciesNetwork, geneTree);

    -- update edgeHash accordingly
    E := select(keys edgeHash, e -> member(e, edges N));
    eHash := new HashTable from apply(E, e -> e => edgeHash#e);
    
    -- update hybridHash accordingly
    hybrids := select(keys hybridHash, k -> member(k, vertices N));
    hHash := new HashTable from apply(hybrids, h -> h => hybridHash#h);

    -- call makeProbability
    makeProbability(N, geneTree, eHash, hHash)
)

-- uncomment to count recursive calls
-- numCalls = 0;
makeProbability = method(TypicalValue => RingElement)
makeProbability(Digraph, Graph, HashTable, HashTable) := (speciesNetwork, geneTree, edgeHash, hybridHash) -> (
    
    -- uncomment to count recursive calls
    --numCalls += 1;
    
    -- if gene tree has less than or equal to 3 leaves return 1
    if #leaves(geneTree) <= 3 then (
        return 1
    );

    -- if network is a star return (# possible coalescences given tree) / (# possible coalescences)
    root := first select(vertices speciesNetwork, v -> isSource(speciesNetwork, v));
    
    if degreeOut(speciesNetwork, root) == #edges speciesNetwork then (
        
        i := degreeOut(speciesNetwork, root);
        numCoalsT := sum(edges geneTree, e -> buildOrdersTree rootTreeFromEdge(geneTree, e));
        numCoals := product(2..i, j -> binomial(j,2));
        return (numCoalsT / numCoals)
    );

    -- look for a cut edge with only leaves below it
    goodEdges := select(edges speciesNetwork, e -> (
        
        isCut := degreeIn(speciesNetwork, e#1) == 1;
        childs := delete(e#1, toList descendants(speciesNetwork, e#1));
        childrenAreLeaves := all(childs, v -> degreeOut(speciesNetwork, v) == 0);
        isCut and (#childs > 0) and childrenAreLeaves
        )
    );

    -- if there is a cutedge with only leaves below it return sum(forests, F -> p(F,e) * mP(updateNetwork, updateGeneTree, updateHash, updateHash))
    if #goodEdges > 0 then (

        e := first goodEdges;
        taxaBelow := toList children(speciesNetwork, e#1);
        forests := possibleCoalescentsInternalEdge(taxaBelow, geneTree);
        
        return sum(forests, coalHistory -> (
            
            c := probOfForestInEdge(coalHistory, e, edgeHash);                          -- get coefficient
            newSpeciesNetwork := updateNetwork(speciesNetwork, e, coalHistory);         -- update species network
            newGeneTree := updateGeneTree(geneTree, coalHistory);                       -- update geneTree
            c * makeProbability(newSpeciesNetwork, newGeneTree, edgeHash, hybridHash)   -- apply recursion
            )
        )
    );

    -- look for a hybrid
    hybrids := keys hybridHash;
    goodHybrids := select(hybrids, v -> degreeOut(speciesNetwork, v) + 1 == #descendants(speciesNetwork, v));

    -- return sum(L, S -> t^#S * (1-t)^#Sc * mP(updateNetwork, geneTree, updateHash, updateHash))
    if #goodHybrids > 0 then (

        hybrid := first goodHybrids;
        hybridVar := hybridHash#hybrid;
        taxa := toList children(speciesNetwork, hybrid);

        return sum(subsets(taxa), L -> (

            R := select(taxa, v -> member(v,L) == false);                                       -- R = complement of L
            tempProb := hybridVar^(#L) * (1 - hybridVar)^(#R);                              
            newSpeciesNetwork := updateNetwork(speciesNetwork, hybrid, L, R);                   -- update network
            newEdgeHash := updateHash(hybrid, edgeHash, newSpeciesNetwork);                     -- update edge hash
            newHybridHash := updateHash(hybrid, hybridHash);                                    -- update hybrid hash
            tempProb * makeProbability(newSpeciesNetwork, geneTree, newEdgeHash, newHybridHash) -- apply recursion
            )
        )
    );
)   






end

