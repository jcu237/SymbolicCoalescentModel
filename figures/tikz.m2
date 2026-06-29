needsPackage "Graphs"

unrootNetwork = N -> (
    (select(edges N, e -> member(-1, e) == false) | {toList children(N, -1)}) / set
)

--"E" => {{"A",2},{"B",2},{"C",1},{"D",0},{"E",0},{0,1},{1,2}},
makeTikzTree = T -> (
    -- T is the tree
    nodeCoords := new HashTable from {
        "A" => {-0.5,-0.87},
        "B" => {-0.5, 0.87},
        "C" => {1,1},
        "D" => {2.5,0.87},
        "E" => {2.5,-0.87},
        2 => {0,0},
        1 => {1,0},
        0 => {2,0}
    };

    e := toList(children(T,-1));
    rootCoords := (nodeCoords#(e#0) + nodeCoords#(e#1)) / 2.0;
    
    nodes := {
        "\\node[int] (u) at (0,0) {};",
        "\\node[int] (v) at (1,0) {};",
        "\\node[int] (w) at (2,0) {};",
        "\\node[leaf,label=below left:$A$] (A) at (-0.5,-0.87) {};",
        "\\node[leaf,label=above left:$B$] (B) at (-0.5, 0.87) {};",
        "\\node[leaf,label=above:$C$] (C) at (1,1) {};",
        "\\node[leaf,label=above right:$D$] (D) at (2.5, 0.87) {};",
        "\\node[leaf,label=below right:$E$] (E) at (2.5,-0.87) {};"
    };

    edges := {
        "\\draw[line width=0.8pt] (A) -- (u) -- (B);",
        "\\draw[line width=0.8pt] (u) -- (v) -- (w);",
        "\\draw[line width=0.8pt] (v) -- (C);",
        "\\draw[line width=0.8pt] (D) -- (w) -- (E);"
    };

    root := {
        "\\node[circle,fill=red,inner sep=1.3pt] (root) at (" | toString(rootCoords#0) | "," | toString(rootCoords#1) | ") {};" 
    };

    return fold(nodes | edges | root, (a,b) -> a | "\n" | b)
)

-- E1 = {{0,"A"},{1,"B"},{3,"C"},{4,"D"},{4,"E"},{0,1},{1,2},{0,2},{2,3},{3,4}}
makeTikz3CycleLeft = N -> (
    -- N = network
    nodeCoords := new HashTable from {
        "A" => {-0.5,-0.86},
        "B" => {-0.5,0.86},
        "C" => {1,1},
        "D" => {2.5,0.87},
        "E" => {2.5,-0.87},
        0 => {-0.17,-0.28},
        1 => {-0.17,0.28},
        2 => {0.33, 0},
        3 => {1,0},
        4 => {2,0}
    };

    rootCoords := sum(toList children(N, -1), v -> nodeCoords#v) / 2;

    reticulationVertices := select(vertices N, v -> degreeIn(N,v) == 2);

    nodes := {
        "\\node[int] (u3) at (0.33,0) {};",
        "\\node[int] (u1) at (-0.17,-0.28) {};",
        "\\node[int] (u2) at (-0.17,0.28) {};",
        "\\node[int] (v) at (1,0) {};",
        "\\node[int] (w) at (2,0) {};",
        "\\node[leaf, label=below left:$A$] (A) at (-.5, -0.86) {};",
        "\\node[leaf, label=above left:$B$] (B) at (-.5, 0.86) {};",
        "\\node[leaf, label=above:$C$] (C) at (1,1) {};",
        "\\node[leaf, label=above right:$D$] (D) at (2.5,0.87) {};",
        "\\node[leaf, label=below right:$E$] (E) at (2.5,-0.87) {};"
    };

    edges := {
        "\\draw[line width=0.8pt] (u1) -- (u2) -- (u3) -- (u1);",
        "\\draw[line width=0.8pt] (A) -- (u1);",
        "\\draw[line width=0.8pt] (B) -- (u2);",
        "\\draw[line width=0.8pt] (u3) -- (v) -- (w);",
        "\\draw[line width=0.8pt] (C) -- (v);",
        "\\draw[line width=0.8pt] (D) -- (w) -- (E);"
    };

    root := {
        "\\node[circle,fill=red,inner sep=1.3pt] (root) at (" | toString(rootCoords#0) | "," | toString(rootCoords#1) | ") {};" 
    };

    rets := apply(reticulationVertices, v -> (
        "\\node[circle,fill=blue,inner sep=1.3pt] at (" | toString(nodeCoords#v#0) | "," | toString(nodeCoords#v#1) | ") {};"
    ));

    return fold(nodes | edges | root | rets, (a,b) -> a | "\n" | b)
)


-- E2 = {{0,"A"},{0,"B"},{2,"C"},{4,"D"},{4,"E"},{0,1},{1,2},{2,3},{1,3},{3,4}}
makeTikz3CycleMiddle = N -> (
    nodeCoords := new HashTable from {
        "A" => {-0.5,-0.86},
        "B" => {-0.5,0.86},
        "C" => {1,1},
        "D" => {2.5,0.87},
        "E" => {2.5,-0.87},
        0 => {0,0},
        1 => {0.67,0},
        2 => {1,0.5},
        3 => {1.33,0},
        4 => {2,0}
    };

    rootCoords := sum(toList children(N, -1), v -> nodeCoords#v) / 2.0;
    reticulationVertices := select(vertices N, v -> degreeIn(N, v) == 2);

    nodes := {
        "\\node[int] (u) at (0,0) {};",
        "\\node[int] (v1) at (0.67,0) {};",
        "\\node[int] (v2) at (1,0.5) {};",
        "\\node[int] (v3) at (1.33,0) {};",
        "\\node[int] (w) at (2,0) {};",
        "\\node[leaf, label=below left:$A$] (A) at (-.5, -0.86) {};",
        "\\node[leaf, label=above left:$B$] (B) at (-.5, 0.86) {};",
        "\\node[leaf, label=above:$C$] (C) at (1,1) {};",
        "\\node[leaf, label=above right:$D$] (D) at (2.5,0.87) {};",
        "\\node[leaf, label=below right:$E$] (E) at (2.5,-0.87) {};"
    };

    edges := {
        "\\draw[line width=0.8pt] (A) -- (u) -- (B);",
        "\\draw[line width=0.8pt] (u) -- (v1) -- (v3) -- (v2) -- (v1);",
        "\\draw[line width=0.8pt] (C) -- (v2);",
        "\\draw[line width=0.8pt] (v3) -- (w);",
        "\\draw[line width=0.8pt] (D) -- (w) -- (E);"
    };

    root := {
        "\\node[circle,fill=red,inner sep=1.3pt] at (" | toString(rootCoords#0) | "," | toString(rootCoords#1) | ") {};"
    };

    rets := apply(reticulationVertices, v -> (
        "\\node[circle,fill=blue,inner sep=1.3pt] at (" | toString(nodeCoords#v#0) | "," | toString(nodeCoords#v#1) | ") {};"
    ));

    return fold(nodes | edges | root | rets, (a,b) -> a | "\n" | b)
)

-- E3 = {{0,"A"},{0,"B"},{1,"C"},{3,"D"},{4,"E"},{0,1},{1,2},{2,3},{3,4},{2,4}}
makeTikz3CycleRight = N -> (
    nodeCoords := new HashTable from {
        "A" => {-0.5,-0.86},
        "B" => {-0.5,0.86},
        "C" => {1,1},
        "D" => {2.5,0.87},
        "E" => {2.5,-0.87},
        0 => {0,0},
        1 => {1,0},
        2 => {1.67,0},
        3 => {2.17,0.29},
        4 => {2.17,-0.29}
    };

    rootCoords := sum(toList children(N, -1), v -> nodeCoords#v) / 2.0;
    reticulationVertices := select(vertices N, v -> degreeIn(N, v) == 2);

    nodes := {
        "\\node[int] (u) at (0,0) {};",
        "\\node[int] (v) at (1,0) {};",
        "\\node[int] (w1) at (1.67,0) {};",
        "\\node[int] (w2) at (2.17,0.29) {};",
        "\\node[int] (w3) at (2.17,-0.29) {};",
        "\\node[leaf, label=below left:$A$] (A) at (-.5, -0.86) {};",
        "\\node[leaf, label=above left:$B$] (B) at (-.5, 0.86) {};",
        "\\node[leaf, label=above:$C$] (C) at (1,1) {};",
        "\\node[leaf, label=above right:$D$] (D) at (2.5,0.87) {};",
        "\\node[leaf, label=below right:$E$] (E) at (2.5,-0.87) {};"
    };

    edges := {
        "\\draw[line width=0.8pt] (A) -- (u) -- (B);",
        "\\draw[line width=0.8pt] (u) -- (v) -- (w1);",
        "\\draw[line width=0.8pt] (C) -- (v);",
        "\\draw[line width=0.8pt] (w1) -- (w2) -- (w3) -- (w1);",
        "\\draw[line width=0.8pt] (w2) -- (D);",
        "\\draw[line width=0.8pt] (w3) -- (E);"
    };

    root := {
        "\\node[circle,fill=red,inner sep=1.3pt] at (" | toString(rootCoords#0) | "," | toString(rootCoords#1) | ") {};"
    };

    rets := apply(reticulationVertices, v -> (
        "\\node[circle,fill=blue,inner sep=1.3pt] at (" | toString(nodeCoords#v#0) | "," | toString(nodeCoords#v#1) | ") {};"
    ));

    return fold(nodes | edges | root | rets, (a,b) -> a | "\n" | b)
)

-- E1 = {{0,"A"},{1,"B"},{4,"C"},{6,"D"},{6,"E"},{0,1},{1,2},{0,2},{2,3},{3,4},{3,5},{4,5},{5,6}}
makeTikz3CycleLeftMiddle = N -> (
    -- N = network
    nodeCoords := new HashTable from {
        "A" => {-0.5,-0.86},
        "B" => {-0.5,0.86},
        "C" => {1,1},
        "D" => {2.5,0.87},
        "E" => {2.5,-0.87},
        0 => {-.17,-0.28},
        1 => {-.17,0.28},
        2 => {0.33,0},
        3 => {0.67,0},
        4 => {1,0.5},
        5 => {1.33,0},
        6 => {2,0}
    };

    rootCoords := sum(toList children(N, -1), v -> nodeCoords#v) / 2;

    reticulationVertices := select(vertices N, v -> degreeIn(N,v) == 2);

    nodes := {
        "\\node[int] (u3) at (0.33,0) {};",
        "\\node[int] (u1) at (-0.17,-0.28) {};",
        "\\node[int] (u2) at (-0.17,0.28) {};",
        "\\node[int] (v1) at (0.67,0) {};",
        "\\node[int] (v2) at (1.33,0) {};",
        "\\node[int] (v3) at (1,0.5) {};",
        "\\node[int] (w) at (2,0) {};",
        "\\node[leaf, label=below left:$A$] (A) at (-.5, -0.86) {};",
        "\\node[leaf, label=above left:$B$] (B) at (-.5, 0.86) {};",
        "\\node[leaf, label=above:$C$] (C) at (1,1) {};",
        "\\node[leaf, label=above right:$D$] (D) at (2.5,0.87) {};",
        "\\node[leaf, label=below right:$E$] (E) at (2.5,-0.87) {};"
    };

    edges := {
        "\\draw[line width=0.8pt] (u1) -- (u2) -- (u3) -- (u1);",
        "\\draw[line width=0.8pt] (A) -- (u1);",
        "\\draw[line width=0.8pt] (B) -- (u2);",
        "\\draw[line width=0.8pt] (u3) -- (v1) -- (v2) -- (v3) -- (v1);",
        "\\draw[line width=0.8pt] (C) -- (v3) -- (v2) -- (w);",
        "\\draw[line width=0.8pt] (D) -- (w) -- (E);"
    };

    root := {
        "\\node[circle,fill=red,inner sep=1.3pt] (root) at (" | toString(rootCoords#0) | "," | toString(rootCoords#1) | ") {};" 
    };

    rets := apply(reticulationVertices, v -> (
        "\\node[circle,fill=blue,inner sep=1.3pt] at (" | toString(nodeCoords#v#0) | "," | toString(nodeCoords#v#1) | ") {};"
    ));

    return fold(nodes | edges | root | rets, (a,b) -> a | "\n" | b)
)

-- E2 = {{0,"A"},{1,"B"},{3,"C"},{5,"D"},{6,"E"},{0,1},{1,2},{0,2},{2,3},{3,4},{4,5},{5,6},{4,6}}
makeTikz3CycleLeftRight = N -> (
    -- N = network
    nodeCoords := new HashTable from {
        "A" => {-0.5,-0.86},
        "B" => {-0.5,0.86},
        "C" => {1,1},
        "D" => {2.5,0.87},
        "E" => {2.5,-0.87},
        0 => {-.17,-0.28},
        1 => {-.17,0.28},
        2 => {0.33,0},
        3 => {1,0},
        4 => {1.67,0},
        5 => {2.17,0.28},
        6 => {2.17,-0.28}
    };

    rootCoords := sum(toList children(N, -1), v -> nodeCoords#v) / 2;

    reticulationVertices := select(vertices N, v -> degreeIn(N,v) == 2);

    nodes := {
        "\\node[int] (u3) at (0.33,0) {};",
        "\\node[int] (u1) at (-0.17,-0.28) {};",
        "\\node[int] (u2) at (-0.17,0.28) {};",
        "\\node[int] (v) at (1,0) {};",
        "\\node[int] (w1) at (1.67,0) {};",
        "\\node[int] (w2) at (2.17,0.28) {};",
        "\\node[int] (w3) at (2.17,-0.28) {};",
        "\\node[leaf, label=below left:$A$] (A) at (-.5, -0.86) {};",
        "\\node[leaf, label=above left:$B$] (B) at (-.5, 0.86) {};",
        "\\node[leaf, label=above:$C$] (C) at (1,1) {};",
        "\\node[leaf, label=above right:$D$] (D) at (2.5,0.87) {};",
        "\\node[leaf, label=below right:$E$] (E) at (2.5,-0.87) {};"
    };

    edges := {
        "\\draw[line width=0.8pt] (u1) -- (u2) -- (u3) -- (u1);",
        "\\draw[line width=0.8pt] (A) -- (u1);",
        "\\draw[line width=0.8pt] (B) -- (u2);",
        "\\draw[line width=0.8pt] (u3) -- (v) -- (w1) -- (w2) -- (w3) -- (w1);",
        "\\draw[line width=0.8pt] (C) -- (v);",
        "\\draw[line width=0.8pt] (D) -- (w2) -- (w3) -- (E);"
    };

    root := {
        "\\node[circle,fill=red,inner sep=1.3pt] (root) at (" | toString(rootCoords#0) | "," | toString(rootCoords#1) | ") {};" 
    };

    rets := apply(reticulationVertices, v -> (
        "\\node[circle,fill=blue,inner sep=1.3pt] at (" | toString(nodeCoords#v#0) | "," | toString(nodeCoords#v#1) | ") {};"
    ));

    return fold(nodes | edges | root | rets, (a,b) -> a | "\n" | b)
)

-- E3 = {{0,"A"},{0,"B"},{2,"C"},{5,"D"},{6,"E"},{0,1},{1,2},{2,3},{1,3},{3,4},{4,5},{5,6},{4,6}}
makeTikz3CycleMiddleRight = N -> (
    -- N = network
    nodeCoords := new HashTable from {
        "A" => {-0.5,-0.86},
        "B" => {-0.5,0.86},
        "C" => {1,1},
        "D" => {2.5,0.87},
        "E" => {2.5,-0.87},
        0 => {0,0},
        1 => {0.67,0},
        2 => {1,0.5},
        3 => {1.33,0},
        4 => {1.67,0},
        5 => {2.17,0.28},
        6 => {2.17,-0.28}
    };

    rootCoords := sum(toList children(N, -1), v -> nodeCoords#v) / 2;

    reticulationVertices := select(vertices N, v -> degreeIn(N,v) == 2);

    nodes := {
        "\\node[int] (u) at (0,0) {};",
        "\\node[int] (v1) at (0.67,0) {};",
        "\\node[int] (v2) at (1,0.5) {};",
        "\\node[int] (v3) at (1.33,0) {};",
        "\\node[int] (w1) at (1.67,0) {};",
        "\\node[int] (w2) at (2.17,0.28) {};",
        "\\node[int] (w3) at (2.17,-0.28) {};",
        "\\node[leaf, label=below left:$A$] (A) at (-.5, -0.86) {};",
        "\\node[leaf, label=above left:$B$] (B) at (-.5, 0.86) {};",
        "\\node[leaf, label=above:$C$] (C) at (1,1) {};",
        "\\node[leaf, label=above right:$D$] (D) at (2.5,0.87) {};",
        "\\node[leaf, label=below right:$E$] (E) at (2.5,-0.87) {};"
    };

    edges := {
        "\\draw[line width=0.8pt] (A) -- (u) -- (B);",
        "\\draw[line width=0.8pt] (u) -- (v1) -- (v2) -- (v3) -- (v1);",
        "\\draw[line width=0.8pt] (C) -- (v2);",
        "\\draw[line width=0.8pt] (v3) -- (w1) -- (w2) -- (w3) -- (w1);",
        "\\draw[line width=0.8pt] (D) -- (w2) -- (w3) -- (E);"
    };

    root := {
        "\\node[circle,fill=red,inner sep=1.3pt] (root) at (" | toString(rootCoords#0) | "," | toString(rootCoords#1) | ") {};" 
    };

    rets := apply(reticulationVertices, v -> (
        "\\node[circle,fill=blue,inner sep=1.3pt] at (" | toString(nodeCoords#v#0) | "," | toString(nodeCoords#v#1) | ") {};"
    ));

    return fold(nodes | edges | root | rets, (a,b) -> a | "\n" | b)    
)

-- E = {{0,"A"},{1,"B"},{4,"C"},{7,"D"},{8,"E"},{0,1},{1,2},{0,2},{2,3},{3,4},{4,5},{3,5},{5,6},{6,7},{7,8},{6,8}}
makeTikz3CycleLeftMiddleRight = N -> (
    -- N = network
    nodeCoords := new HashTable from {
        "A" => {-0.5,-0.86},
        "B" => {-0.5,0.86},
        "C" => {1,1},
        "D" => {2.5,0.87},
        "E" => {2.5,-0.87},
        0 => {-0.17,-0.28},
        1 => {-0.17,0.28},
        2 => {0.33, 0},
        3 => {0.67, 0},
        4 => {1,0.5},
        5 => {1.33,0},
        6 => {1.67,0},
        7 => {2.17,0.28},
        8 => {2.17,-0.28},
    };

    rootCoords := sum(toList children(N, -1), v -> nodeCoords#v) / 2;

    reticulationVertices := select(vertices N, v -> degreeIn(N,v) == 2);

    nodes := {
        "\\node[int] (u1) at (-0.17,-0.28) {};",
        "\\node[int] (u2) at (-0.17,0.28) {};",
        "\\node[int] (u3) at (0.33, 0) {};",
        "\\node[int] (v1) at (0.67,0) {};",
        "\\node[int] (v2) at (1,0.5) {};",
        "\\node[int] (v3) at (1.33,0) {};",
        "\\node[int] (w1) at (1.67,0) {};",
        "\\node[int] (w2) at (2.17,0.28) {};",
        "\\node[int] (w3) at (2.17,-0.28) {};",
        "\\node[leaf, label=below left:$A$] (A) at (-.5, -0.86) {};",
        "\\node[leaf, label=above left:$B$] (B) at (-.5, 0.86) {};",
        "\\node[leaf, label=above:$C$] (C) at (1,1) {};",
        "\\node[leaf, label=above right:$D$] (D) at (2.5,0.87) {};",
        "\\node[leaf, label=below right:$E$] (E) at (2.5,-0.87) {};"
    };

    edges := {
        "\\draw[line width=0.8pt] (A) -- (u1) -- (u2) -- (B);",
        "\\draw[line width=0.8pt] (u2) -- (u3) -- (u1);",
        "\\draw[line width=0.8pt] (u3) -- (v1) -- (v2) -- (v3) -- (v1);",
        "\\draw[line width=0.8pt] (C) -- (v2);",
        "\\draw[line width=0.8pt] (v3) -- (w1) -- (w2) -- (w3) -- (w1);",
        "\\draw[line width=0.8pt] (D) -- (w2) -- (w3) -- (E);"
    };

    root := {
        "\\node[circle,fill=red,inner sep=1.3pt] (root) at (" | toString(rootCoords#0) | "," | toString(rootCoords#1) | ") {};" 
    };

    rets := apply(reticulationVertices, v -> (
        "\\node[circle,fill=blue,inner sep=1.3pt] at (" | toString(nodeCoords#v#0) | "," | toString(nodeCoords#v#1) | ") {};"
    ));

    return fold(nodes | edges | root | rets, (a,b) -> a | "\n" | b) 
)


-- {{0,"A"},{1,"B"},{2,"C"},{4,"D"},{4,"E"},{0,1},{1,2},{2,3},{0,3},{3,4}}
makeTikz4Cycle = N -> (
    -- N a network
    nodeCoords := new HashTable from {
        "A" => {0,-1},
        "B" => {-1,0}, 
        "C" => {0,1},
        "D" => {2,0.87},
        "E" => {2,-0.87},
        0   => {0,-0.5},
        1   => {-0.5,0},
        2   => {0,0.5},
        3   => {0.5,0},
        4   => {1.5,0}
    };

    rootCoords := sum(toList children(N, -1), v -> nodeCoords#v) / 2;

    reticulationVertices := select(vertices N, v -> degreeIn(N,v) == 2);

    nodes := {
        "\\node[int] (u0) at (0,-0.5) {};",
        "\\node[int] (u1) at (-0.5,0) {};",
        "\\node[int] (u2) at (0,0.5) {};",
        "\\node[int] (u3) at (0.5,0) {};",
        "\\node[int] (u4) at (1.5,0) {};",
        "\\node[leaf, label=below:$A$] (A) at (0,-1) {};",
        "\\node[leaf, label=left:$B$] (B) at (-1, 0) {};",
        "\\node[leaf, label=above:$C$] (C) at (0,1) {};",
        "\\node[leaf, label=above right:$D$] (D) at (2,0.87) {};",
        "\\node[leaf, label=below right:$E$] (E) at (2,-0.87) {};"
    };

    edges := {
        "\\draw[line width=0.8pt] (u3) -- (u0) -- (u1) -- (u2) -- (u3) -- (u4);",
        "\\draw[line width=0.8pt] (u0) -- (A);",
        "\\draw[line width=0.8pt] (u1) -- (B);",
        "\\draw[line width=0.8pt] (u2) -- (C);",
        "\\draw[line width=0.8pt] (u4) -- (D);",
        "\\draw[line width=0.8pt] (u4) -- (E);"
    };

    root := {
        "\\node[circle,fill=red,inner sep=1.3pt] (root) at (" | toString(rootCoords#0) | "," | toString(rootCoords#1) | ") {};" 
    };

    rets := apply(reticulationVertices, v -> (
        "\\node[circle,fill=blue,inner sep=1.3pt] at (" | toString(nodeCoords#v#0) | "," | toString(nodeCoords#v#1) | ") {};"
    ));

    return fold(nodes | edges | root | rets, (a,b) -> a | "\n" | b) 
)

-- {{0,"A"},{1,"B"},{2,"C"},{5,"D"},{6,"E"},{0,1},{1,2},{2,3},{0,3},{3,4},{4,5},{5,6},{4,6}}
makeTikz34Cycle = N -> (
-- N a network
    nodeCoords := new HashTable from {
        "A" => {0,-1},
        "B" => {-1,0}, 
        "C" => {0,1},
        "D" => {2,0.87},
        "E" => {2,-0.87},
        0   => {0,-0.5},
        1   => {-0.5,0},
        2   => {0,0.5},
        3   => {0.5,0},
        4   => {1.17,0},
        5   => {1.66,0.29},
        6   => {1.66,-0.29}
    };

    rootCoords := sum(toList children(N, -1), v -> nodeCoords#v) / 2;

    reticulationVertices := select(vertices N, v -> degreeIn(N,v) == 2);

    nodes := {
        "\\node[int] (u0) at (0,-0.5) {};",
        "\\node[int] (u1) at (-0.5,0) {};",
        "\\node[int] (u2) at (0,0.5) {};",
        "\\node[int] (u3) at (0.5,0) {};",
        "\\node[int] (u4) at (1.17,0) {};",
        "\\node[int] (u5) at (1.66,0.29) {};",
        "\\node[int] (u6) at (1.66,-0.29) {};",
        "\\node[leaf, label=below:$A$] (A) at (0,-1) {};",
        "\\node[leaf, label=left:$B$] (B) at (-1, 0) {};",
        "\\node[leaf, label=above:$C$] (C) at (0,1) {};",
        "\\node[leaf, label=above right:$D$] (D) at (2,0.87) {};",
        "\\node[leaf, label=below right:$E$] (E) at (2,-0.87) {};"
    };

    edges := {
        "\\draw[line width=0.8pt] (u3) -- (u0) -- (u1) -- (u2) -- (u3) -- (u4) -- (u5) -- (u6) -- (u4);",
        "\\draw[line width=0.8pt] (u0) -- (A);",
        "\\draw[line width=0.8pt] (u1) -- (B);",
        "\\draw[line width=0.8pt] (u2) -- (C);",
        "\\draw[line width=0.8pt] (u5) -- (D);",
        "\\draw[line width=0.8pt] (u6) -- (E);"
    };

    root := {
        "\\node[circle,fill=red,inner sep=1.3pt] (root) at (" | toString(rootCoords#0) | "," | toString(rootCoords#1) | ") {};" 
    };

    rets := apply(reticulationVertices, v -> (
        "\\node[circle,fill=blue,inner sep=1.3pt] at (" | toString(nodeCoords#v#0) | "," | toString(nodeCoords#v#1) | ") {};"
    ));

    return fold(nodes | edges | root | rets, (a,b) -> a | "\n" | b) 
)



decideTikzFunction = new HashTable from {
    set({{"A",2},{"B",2},{"C",1},{"D",0},{"E",0},{0,1},{1,2}} / set) => makeTikzTree,
    set({{0,"A"},{1,"B"},{3,"C"},{4,"D"},{4,"E"},{0,1},{1,2},{0,2},{2,3},{3,4}} / set) => makeTikz3CycleLeft,
    set({{0,"A"},{0,"B"},{2,"C"},{4,"D"},{4,"E"},{0,1},{1,2},{2,3},{1,3},{3,4}} / set) => makeTikz3CycleMiddle,
    set({{0,"A"},{0,"B"},{1,"C"},{3,"D"},{4,"E"},{0,1},{1,2},{2,3},{3,4},{2,4}} / set) => makeTikz3CycleRight,
    set({{0,"A"},{1,"B"},{4,"C"},{6,"D"},{6,"E"},{0,1},{1,2},{0,2},{2,3},{3,4},{3,5},{4,5},{5,6}} / set) => makeTikz3CycleLeftMiddle,
    set({{0,"A"},{1,"B"},{3,"C"},{5,"D"},{6,"E"},{0,1},{1,2},{0,2},{2,3},{3,4},{4,5},{5,6},{4,6}} / set) => makeTikz3CycleLeftRight,
    set({{0,"A"},{0,"B"},{2,"C"},{5,"D"},{6,"E"},{0,1},{1,2},{2,3},{1,3},{3,4},{4,5},{5,6},{4,6}} / set) => makeTikz3CycleMiddleRight,
    set({{0,"A"},{1,"B"},{4,"C"},{7,"D"},{8,"E"},{0,1},{1,2},{0,2},{2,3},{3,4},{4,5},{3,5},{5,6},{6,7},{7,8},{6,8}} / set) => makeTikz3CycleLeftMiddleRight,
    set({{0,"A"},{1,"B"},{2,"C"},{4,"D"},{4,"E"},{0,1},{1,2},{2,3},{0,3},{3,4}} / set) => makeTikz4Cycle,
    set({{0,"A"},{1,"B"},{2,"C"},{5,"D"},{6,"E"},{0,1},{1,2},{2,3},{0,3},{3,4},{4,5},{5,6},{4,6}}/ set) => makeTikz34Cycle
}

end
restart
mergedBuckets = {
    {{27, 28, 29, 30, 31, 32, 33},{81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94}},
    {{26}                        ,{66, 77}                                                },
    {{12}                        ,{}                                                      },
    {{13}                        ,{}                                                      },
    {{9, 14, 17}                 ,{32, 36, 39, 43, 47, 50}                                },
    {{18}                        ,{59, 70}                                                },
    {{3}                         ,{}                                                      },
    {{4}                         ,{}                                                      },
    {{22}                        ,{}                                                      },
    {{21}                        ,{}                                                      },
    {{5}                         ,{9, 20}                                                 }, 
    {{6}                         ,{10, 21}                                                },  
    {{0}                         ,{5, 16}                                                 }, 
    {{8}                         ,{12, 23}                                                }, 
    {{19}                        ,{60, 71}                                                },
    {{23}                        ,{63, 74}                                                }, 
    {{24}                        ,{64, 75}                                                },
    {{20}                        ,{61, 72}                                                }, 
    {{7}                         ,{11, 22}                                                },
    {{2}                         ,{7, 18}                                                 },
    {{10, 15, 16}                ,{33, 37, 38, 44, 48, 49}                                },
    {{1}                         ,{6, 17}                                                 },
    {{25}                        ,{65, 76}                                                },
    {{11}                        ,{34, 45}                                                },
    {{}                          ,{54, 55, 56, 57, 58, 62, 67, 68, 69, 73, 78, 79, 80}    },
    {{}                          ,{0, 1, 2, 3, 4, 8, 13, 14, 15, 19, 24, 25, 26}          },
    {{}                          ,{27, 28, 29, 30, 31, 35, 40, 41, 42, 46, 51, 52, 53}    }
}


needs "./tikz.m2"
needs "./../graphs/fourCycleGraphs.m2"
needs "./../graphs/threeAndFourCycleGraphs.m2"

preamble = {
    "\\documentclass{standalone}",
    "\\usepackage{tikz}",
    "\\usetikzlibrary{arrows.meta}",
    "\\begin{document}",
    "\\begin{tikzpicture}[>=Stealth, every node/.style={font=\\small},dot/.style={circle,fill=black,inner sep=1.3pt},leaf/.style={dot},int/.style={dot},]"
}

postamble = {
    "\\end{tikzpicture}",
    "\\end{document}"
}

fileNumber = 1
for bucket in mergedBuckets do (
    four := bucket#0;
    threeFour := bucket#1;

    graphFour := if #four > 0 then E4_four / (e -> digraph e) else {};
    graphThreeFour := if #threeFour > 0 then E34_threeFour / digraph else {};


    networks := graphFour | graphThreeFour;

    columnIndex := 0;
    rowIndex := 0;

    tikzForNets := apply(networks, N -> (
        E := set(unrootNetwork N);
        makeTikzFun := decideTikzFunction#E;
        tikzCode := makeTikzFun N;
        shift := (5 * (columnIndex % 3), 3 * rowIndex);
        beginScope := "\\begin{scope}[shift={" | toString shift | "}]\n";
        endScope := "\\end{scope}";
       
        scope := beginScope | tikzCode | "\n" | endScope;

        columnIndex += 1;
        if columnIndex > 0 and columnIndex % 3 == 0 then rowIndex += 1;
        
        scope
    ));

    file := "three_four_blob_tree/bucket" | toString(fileNumber) | ".tex";
    file << fold(preamble | tikzForNets | postamble, (a,b) -> a | "\n" | b) << close;
    fileNumber += 1;
)

end


restart
needs "tikz.m2"
needs "../graphs/treeGraphs.m2"
needs "../graphs/threeCycleGraphs.m2"
needs "../graphs/twoThreeCycleGraphs.m2"
needs "../graphs/threeThreeCycleGraphs.m2"

buckets = {
	{{6},{1,10,53,62},{70,81,97,108},{}},
	{{1},{52,61},{},{}},
	{{5},{3,12,55,64},{72,83,99,110},{}},
	{{2},{2,11,54,63},{71,82,98,109},{}},
	{{3},{4,13},{},{}},
	{{4},{5,14},{},{}},
	{{0},{51,60},{},{}},
	{{},{46,47,48,49,50,56,57,58,59,65,66,67,68},{64,65,66,67,68,73,77,78,79,84,88,89,90,91,92,93,94,95,100,104,105,106,111,115,116,117},{}},
	{{},{24,33},{1,9,28,36,134,143,159,170},{6,15,30,43,78,87,102,115}},
	{{},{30,31,39,40},{7,12,13,14,18,21,22,23,34,39,40,41,45,48,49,50,54,55,56,57,58,59,60,61,62,63,156,157,167,168,178,179,185,186},{28,32,33,34,41,45,46,47,54,57,58,59,63,66,67,68,100,104,105,106,113,117,118,119,126,129,130,131,135,138,139,140,144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163}},
	{{},{0,6,7,8,9,15,16,17,18,19,20,21,22},{69,74,75,76,80,85,86,87,96,101,102,103,107,112,113,114,118,119,120,121,122,123,124,125,126,127},{}},
	{{},{23,27,28,29,36,37,38,42,43,44,45},{0,4,5,6,15,16,17,20,24,25,26,27,31,32,33,42,43,44,47,51,52,53,133,136,137,138,142,145,146,147,161,162,163,172,173,174,181,182,183,184,188,189,190,191},{5,8,9,10,14,17,18,19,35,36,37,48,49,50,56,60,61,62,65,69,70,71,77,80,81,82,86,89,90,91,107,108,109,120,121,122,128,132,133,134,137,141,142,143}},
	{{},{25,26,34,35},{2,3,10,11,29,30,37,38,128,129,130,131,132,135,139,140,141,144,148,149,150,151,152,153,154,155,160,164,165,166,171,175,176,177},{0,1,2,3,4,7,11,12,13,16,20,21,22,23,24,25,26,27,31,38,39,40,44,51,52,53,72,73,74,75,76,79,83,84,85,88,92,93,94,95,96,97,98,99,103,110,111,112,116,123,124,125}},
	{{},{32,41},{8,19,35,46,158,169,180,187},{29,42,55,64,101,114,127,136}}
}

preamble = {
    "\\documentclass{standalone}",
    "\\usepackage{tikz}",
    "\\usetikzlibrary{arrows.meta}",
    "\\begin{document}",
    "\\begin{tikzpicture}[>=Stealth, every node/.style={font=\\small},dot/.style={circle,fill=black,inner sep=1.3pt},leaf/.style={dot},int/.style={dot},]"
}

postamble = {
    "\\end{tikzpicture}",
    "\\end{document}"
}

fileNumber = 1
for bucket in buckets do (
    tree := bucket#0;
    cycles13 := bucket#1;
    cycles23 := bucket#2;
    cycles33 := bucket#3; 

    graphTree := if #tree > 0 then ETree_tree / (e -> digraph e) else {};
    graph13 := if #cycles13 > 0 then E13_cycles13 / digraph else {};
    graph23 := if #cycles23 > 0 then E23_cycles23 / digraph else {};
    graph33 := if #cycles33 > 0 then E33_cycles33 / digraph else {};

    networks := graphTree | graph13 | graph23 | graph33;

    columnIndex := 0;
    rowIndex := 0;

    tikzForNets := apply(networks, N -> (
        E := set(unrootNetwork N);
        makeTikzFun := decideTikzFunction#E;
        tikzCode := makeTikzFun N;
        shift := (5 * (columnIndex % 3), 3 * rowIndex);
        beginScope := "\\begin{scope}[shift={" | toString shift | "}]\n";
        endScope := "\\end{scope}";
       
        scope := beginScope | tikzCode | "\n" | endScope;

        columnIndex += 1;
        if columnIndex > 0 and columnIndex % 3 == 0 then rowIndex += 1;
        
        scope
    ));

    file := "fully_resolved_blob_tree/bucket" | toString(fileNumber) | ".tex";
    file << fold(preamble | tikzForNets | postamble, (a,b) -> a | "\n" | b) << close;
    fileNumber += 1;
)



