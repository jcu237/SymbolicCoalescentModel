restart 
needs "./SCM/SCM.m2"

geneTrees = getGeneTrees 5

rootedTrees = apply(edges first geneTrees, e -> rootTreeFromEdge(first geneTrees, e))

RQuintet = QQ[u_1..u_15]
S = QQ[x_1..x_3]

edgeHashes = new HashTable from
for T in rootedTrees list (
    E := select(edges T, e -> degreeOut(T,e#1) > 0);
    T => new HashTable from apply(#E, i -> E#i => x_(i+1))
)

hybridHash = new HashTable from {}

quintetParams = 
for T in rootedTrees list (
    map(S, RQuintet, apply(geneTrees, t -> makeProb(T,t,edgeHashes#T,hybridHash)))
)

quintetIdeals = quintetParams / ker

assert(#quintetIdeals == 7)

geneTreesABCD = getGeneTrees 4;

geneTreesABCE = 
for t in geneTreesABCD list (
    E := edges(t) / toList;
    graph for e in E list (
        if member("D", e) then (
            i := position(e, j -> j === "D");
            replace(i, "E", e)
        ) else (
            e
        )
    )
)

geneTreesABDE = 
for t in geneTreesABCD list (
    E := edges(t) / toList;
    graph for e in E list (
        if member("C", e) then (
            i := position(e, j -> j === "C");
            replace(i, "E", e)
        ) else (
            e
        )
    )
)

geneTreesACDE = 
for t in geneTreesABCD list (
    E := edges(t) / toList;
    graph for e in E list (
        if member("B", e) then (
            i := position(e, j -> j === "B");
            replace(i, "E", e)
        ) else (
            e
        )
    )
)

geneTreesBCDE =
for t in geneTreesABCD list (
    E := edges(t) / toList;
    graph for e in E list (
        if member("A", e) then (
            i := position(e, j -> j === "A");
            replace(i, "E", e)
        ) else (
            e
        )
    )
)


quarts = {
    "AB|CD", "AC|BD", "AD|BC", 
    "AB|CE", "AC|BE", "AE|BC", 
    "AB|DE", "AE|BD", "AD|BE",
    "AE|CD", "AC|DE", "AD|CE",
    "BE|CD", "BD|CE", "BC|DE"
}
    

RQuartet = QQ[quarts / (q -> w_q)]
quartetParams = 
for T in rootedTrees list (
    imABCD = apply(geneTreesABCD, t -> makeProb(T,t,edgeHashes#T,hybridHash));
    imABCE = apply(geneTreesABCE, t -> makeProb(T,t,edgeHashes#T,hybridHash));
    imABDE = apply(geneTreesABDE, t -> makeProb(T,t,edgeHashes#T,hybridHash));
    imACDE = apply(geneTreesACDE, t -> makeProb(T,t,edgeHashes#T,hybridHash));
    imBCDE = apply(geneTreesBCDE, t -> makeProb(T,t,edgeHashes#T,hybridHash));
    im = imABCD | imABCE | imABDE | imACDE | imBCDE;
    map(S, RQuartet, im)
)


quartetIdeals = quartetParams / ker
assert(1 == #unique quartetIdeals)
JQuartet = first quartetIdeals

idealFromPaper = ideal {
    w_"BE|CD" + w_"BD|CE" + w_"BC|DE" - 1,
    w_"AE|CD" + w_"AD|CE" + w_"AC|DE" - 1,
    w_"AE|BD" + w_"AD|BE" + w_"AB|DE" - 1,
    w_"AE|BC" + w_"AC|BE" + w_"AB|CE" - 1,
    w_"AD|BC" + w_"AC|BD" + w_"AB|CD" - 1,
    w_"AB|CD" - w_"AB|CE",
    w_"AC|BD" - w_"AD|BC",
    w_"AC|BD" - w_"AC|BE",
    w_"AC|BD" - w_"AE|BC",
    w_"AD|BE" - w_"AE|BD",
    w_"BC|DE" - w_"AC|DE",
    w_"BD|CE" - w_"AD|CE",
    w_"BD|CE" - w_"BE|CD",
    w_"BD|CE" - w_"AE|CD",
    3*w_"AE|BC"*w_"BC|DE" - 3*w_"AE|BC" + 2*w_"AD|BE"
}

JQuartet == idealFromPaper

basis(1,RQuartet) % JQuartet
support(basis(1,RQuartet) % JQuartet)
---------------
-- marginalize
---------------

marg =
for q in quarts list (
    split := {set {q#0, q#1}, set {q#3,q#4}};
    compatTrees := {};
    for i from 1 to #geneTrees do (
        T := geneTrees#(i-1);
        for e in edges T do (
            cc := connectedComponents(graph delete(e, edges T));
            cc = cc / set;
            cc = cc / (l -> l * set toList "ABCDE"); 
            if any(split, s -> member(s, cc)) then compatTrees = compatTrees | {u_i};
        );
    );
    sum unique compatTrees
)

MARG = map(RQuintet, RQuartet, marg)

preims = apply(quintetIdeals, I -> preimage_MARG(I))
assert all(preims, I -> I == Jquartet)

phi0 = first quartetParams
phi0 w_"AE|BC"
phi0 w_"BC|DE"

phi1 = quartetParams#1
phi1 w_"AE|BC"
phi1 w_"BC|DE"

netList for f in quartetParams list (
    {f w_"AE|BC", f w_"BC|DE"}
)
