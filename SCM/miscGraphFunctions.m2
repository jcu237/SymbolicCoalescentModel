Digraph == Digraph := (N, M) -> (set vertices N === set vertices M) and (set edges N === set edges M)

-- Input: m, {m1..mk} s.t. m = m1 + .. + mk and mi>=0
-- Output: m!/(m1!..mk!)
multinomial = (m,L) -> (
    if m != sum(L) then (
        error("incompatible sizes");
    );

    if any(L | {m}, n -> n < 0) then (
        error("expected positive numbers");
    );

    m! / product(L, n -> n!)
)

-- Input: undirected tree and an edge
-- Output: a rooted tree with root placed in middle of edge
rootTreeFromEdge = (T, e) -> (

    -- 1) remove e
    ee := toList e;
    E := edges(T);
    newE := delete(set e, E);
    
    -- 2) add {-1, e#0} and {-1, e#1} and make undirected graph with these added
    newE = newE | {set {-1_ZZ, ee#0}, set {-1_ZZ, ee#1}};
    newT := graph newE;
    
    -- 3) depth first search tree to direct edges in the tree away from root
    toSearch := {-1_ZZ};
    seen := {-1_ZZ};
    directedEdges := {};
    
    while #seen < #vertices(newT) do (
        
        v := last toSearch;

        for w in toList neighbors(newT, v) do (
        
            if member(w, seen) == false then (
                directedEdges = directedEdges | {{v, w}};
                seen = seen | {w};
                toSearch = toSearch | {w};
            );

        );
        
        toSearch = delete(v, toSearch);

    );

    return digraph directedEdges
)

rootTreeFromVertex = (T, v) -> (
    
    toSearch := {v};
    seen := {v};
    directedEdges := {};

    while #seen < #vertices T do (
        
        w := last toSearch;
        
        for u in toList neighbors(T, w) do (

            if member(u, seen) == false then (
                directedEdges = directedEdges | {{w,u}};
                seen = seen | {u};
                toSearch = toSearch | {u};
            );
        );

        toSearch = delete(w, toSearch);
    );

    return digraph directedEdges
)

rootNetworkFromEdge = (N, e, retVerts) -> (

    retEdges := new HashTable from for v in retVerts list (
        
        goodNeighbs := select(toList neighbors(N, v), u -> (
            isConnected graph(vertices N, delete(set{u,v}, edges N))
        ));

        v => apply(goodNeighbs, u -> {u, v})
    );

    edgesToDelete := for v in retVerts list (
        if e == set(retEdges#v#0) then (
            retEdges#v#1
        ) else (
            retEdges#v#0
        )
    );

    T := graph(select(edges N, ee -> member(ee, edgesToDelete / (eee -> set eee)) == false));

    rootedT := rootTreeFromEdge(T, e);

    return digraph(edges (rootedT) | edgesToDelete)
)

unrootTree = T -> (

    root := first select(vertices T, v -> isSource(T,v));
    keepTheseEdges := select(edges T, e -> member(root, e) == false);
    return graph(keepTheseEdges | {toList children(T,root)})
)

-- Input: a rooted tree and a vertex
-- Output: induced sub-tree by taking v and all its descendants
getSubTree = (T,v) -> (
    D := descendants(T,v);
    digraph select(edges T, e -> isSubset(e, D))
)

-- Input: a rooted tree and a list of vertices
-- Output: rooted binary forest by taking V and all their descendants
getSubForest = (T,V) -> (
    D := sum(V, v -> descendants(T,v));
    digraph select(edges T, e -> isSubset(e, D))
)

-- Input: a rooted tree
-- Output: leaves of tree
getLeavesOfDigraph = T -> select(vertices T, v -> degreeOut(T,v) == 0)





getGeneTrees = k -> (

    if k <= 2 or k >= 6 then return {};

    if k == 5 then (
        return {
            graph {{"A",0},{"B",0},{0,1},{"C",1},{1,2},{"D",2},{"E",2}},
            graph {{"A",0},{"B",0},{0,1},{"D",1},{1,2},{"C",2},{"E",2}},
            graph {{"A",0},{"B",0},{0,1},{"E",1},{1,2},{"D",2},{"C",2}},
            graph {{"A",0},{"C",0},{0,1},{"B",1},{1,2},{"D",2},{"E",2}},
            graph {{"A",0},{"C",0},{0,1},{"D",1},{1,2},{"B",2},{"E",2}},
            graph {{"A",0},{"C",0},{0,1},{"E",1},{1,2},{"D",2},{"B",2}},
            graph {{"A",0},{"D",0},{0,1},{"B",1},{1,2},{"C",2},{"E",2}},
            graph {{"A",0},{"D",0},{0,1},{"C",1},{1,2},{"B",2},{"E",2}},
            graph {{"A",0},{"D",0},{0,1},{"E",1},{1,2},{"B",2},{"C",2}},
            graph {{"A",0},{"E",0},{0,1},{"B",1},{1,2},{"D",2},{"C",2}},
            graph {{"A",0},{"E",0},{0,1},{"C",1},{1,2},{"D",2},{"B",2}},
            graph {{"A",0},{"E",0},{0,1},{"D",1},{1,2},{"B",2},{"C",2}},
            graph {{"B",0},{"C",0},{0,1},{"A",1},{1,2},{"D",2},{"E",2}},
            graph {{"D",0},{"B",0},{0,1},{"A",1},{1,2},{"C",2},{"E",2}},
            graph {{"E",0},{"B",0},{0,1},{"A",1},{1,2},{"D",2},{"C",2}}
        };
    );

    if k == 4 then (
        return {
            graph {{"A",0},{"B",0},{0,1},{"C",1},{"D",1}},
            graph {{"A",0},{"C",0},{0,1},{"B",1},{"D",1}},
            graph {{"A",0},{"D",0},{0,1},{"B",1},{"C",1}}
        };
    );

    if k == 3 then (
        return {
            graph {{"A",0},{"B",0},{"C",0}}
        };
    );
)
