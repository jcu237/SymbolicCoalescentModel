updateNetwork = method(TypicalValue => Digraph)

-- Input: network, a cut-edge e, coalescent forest
-- Output: contracts e and updates leaves below contracted edge according to forest
updateNetwork(Digraph, List, Digraph) := (speciesNetwork, e, coalHistory) -> (

    -- e = u -> v
    (u,v) := toSequence e; 
    
    -- get leaves below v
    oldTaxa := toList children(speciesNetwork, v);
    
    -- update new taxa according to coalHistory
    comps := connectedComponents graph(vertices coalHistory, edges coalHistory);
    newTaxa := for C in comps list (
        groupedTaxa := sort select(C, taxon -> member(taxon, oldTaxa));
        groupedTaxa = fold(groupedTaxa, (a,b) -> a | b);
        fold(sort toList groupedTaxa, (a,b) -> a | b)
    );

    -- make new edge set
    E := select(edges speciesNetwork, e -> member(v, e) == false) | apply(newTaxa, a -> {u, a});
    return digraph E
)

-- Input: network, gene tree
-- Output: network induced by leaves of gene tree
updateNetwork(Digraph, Graph) := (speciesNetwork, geneTree) -> (
    
    L := set select(vertices speciesNetwork, v -> degreeOut(speciesNetwork, v) == 0);
    
    if set leaves geneTree === L then (
        return speciesNetwork;
    );

    badTaxa := select(L, v -> member(v, leaves geneTree) == false);
    badVertices := select(vertices speciesNetwork, v -> isSubset(descendants(speciesNetwork, v) * L, badTaxa));

    return digraph select(edges speciesNetwork, e -> all(badVertices, v -> member(v,e)==false));
)

-- Input: species network
-- Output: removes leaves that aren't strings. 
-- (needed when doing parental trees)
updateNetwork(Digraph) := speciesNetwork -> (

    L := select(edges speciesNetwork, e -> degreeOut(speciesNetwork,e#1) == 0);

    while any(L, leaf -> not(class(leaf#1) === String)) do (
        edgesToRemove := select(L, leaf -> not(class(leaf#1) === String));
        speciesNetwork = digraph select(edges speciesNetwork, e -> member(e, edgesToRemove) == false);
        L = select(edges speciesNetwork, e -> degreeOut(speciesNetwork, e#1) == 0);
    );

    return speciesNetwork
)

-- Input: network, hybrid node (in-degree 2), taxa going left, taxa going right
-- Output: parental network where hybrid is split
updateNetwork(Digraph, Thing, List, List) := (speciesNetwork, hybrid, taxaLeft, taxaRight) -> (

    (u,v) := toSequence sort toList parents(speciesNetwork, hybrid);
    -- keep rest of network the same
    E := select(edges speciesNetwork, e -> member(hybrid, e) == false);
    -- make some go left
    E = E | {{u, hybrid}} | apply(taxaLeft, a -> {hybrid, a});
    -- make some go right
    E = E | {{v, -hybrid-10}} | apply(taxaRight, a -> {-hybrid-10, a});

    return updateNetwork(digraph E)

)


updateGeneTree = method(TypicalValue => Graph)

--Input: a gene tree
--Output: same gene tree but degree two nodes are supressed
updateGeneTree(Graph) := geneTree -> (
    
    while any(vertices geneTree, v -> degree(geneTree, v) == 2) do (

        degreeTwoVertex := first select(vertices geneTree, v -> degree(geneTree, v) == 2);
        oldEdges := select(edges geneTree, e -> member(degreeTwoVertex, e) == false);
        newEdges := {neighbors(geneTree, degreeTwoVertex)};
        geneTree = graph(oldEdges | newEdges);
    );
    
    return geneTree
)

-- Input: gene tree and forest representing a partial coalescent history
-- Output: updated gene tree
updateGeneTree(Graph, Digraph) := (geneTree, coalHistory) -> (
    
    sources := select(vertices coalHistory, v -> isSource(coalHistory, v));
    taxaBelow := getLeavesOfDigraph(coalHistory);

    if (set taxaBelow === set leaves geneTree) and #sources == 1 then (
        
        allCoal := sort leaves geneTree;
        allCoal = sort toList fold(allCoal, (a,b) -> a | b);
        allCoal = fold(allCoal, (a,b) -> a | b);
        return graph({allCoal},{})
    );

    E := {};
    comps := connectedComponents(graph(vertices coalHistory, edges coalHistory));

    for v in sources do (

        comp := first select(comps, C -> member(v, C));
        taxaBelowV := sort select(comp, u -> class(u) === String);
        taxaAboveV := sort toList fold(taxaBelowV, (a,b) -> a | b);
        taxaAboveV = fold(taxaAboveV, (a,b) -> a | b);
        E = E | {set{v, taxaAboveV}};
    );

    E = E | select(edges geneTree, e -> any(comps, C -> isSubset(e, C)) == false);
    
    return updateGeneTree(graph E)
)