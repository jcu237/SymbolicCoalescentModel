needsPackage "Graphs"
-- uncomment whichever set of graphs you want to check and save
needs "fiveCycleGraphs.m2"
-- needs "fourCycleGraphs.m2"
-- needs "threeAndFourCycleGraphs.m2"
-- needs "threeCycleGraphs.m2"
-- needs "threeThreeCycleGraphs.m2"
-- needs "treeGraphs.m2"
-- needs "twoThreeCycleGraphs.m2"

E = delete(null, E)

L = {"A","B","C","D","E"}
splits = for D in E list (
    G := graph D;
    cutedges := select(edges G, e -> (#connectedComponents(graph(vertices G, delete(e, edges G)))) == 2);
    sort unique for e in cutedges list (
        C := connectedComponents graph(vertices G, delete(e, edges G));
        sort apply(C, c -> sort select(c, v -> member(v, L)))
    )
)

end

-- come down here and check that they all have the same splits, i.e. their tree of blobs are the same.
restart

needs "checkSplits.m2"

assert(#unique splits == 1)
netList first unique splits

