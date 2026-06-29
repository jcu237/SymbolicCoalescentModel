needsPackage "MultigradedImplicitization"

R = QQ[u_0..u_15]
S = QQ[x_0..x_8, t_1..t_2]

needs "./../params/oneThreeCycleParams.m2"
needs "./../graphs/threeCycleGraphs.m2" 

avoidStructs = {
    {{0,1},{1,2},{0,2},{0,"A"},{1,"B"}} / set,
    {{2,3},{3,4},{2,4},{3,"D"},{4,"E"}} / set
}

trimmedE13 = positions(delete(null,E13), e -> all(avoidStructs, struct -> isSubset(struct, e / set) == false))

IM13 = apply(49, i -> map(S, R, value concatenate("im", toString i)));

idealHash13 = new MutableHashTable from {}

for i from 0 to 48 do (
    
    I := ideal flatten values componentsOfKernel(2,IM13#i);

    if idealHash13#?I then (
        idealHash13#I = idealHash13#I | {i};
    ) else (
        idealHash13#I = {i};
    );
)

apply(keys idealHash13, I -> (isPrime I, dim I, degree I))

apply(keys idealHash13, I -> dim I == rank jacobian matrix map(S,R,value concatenate("im", toString first idealHash13#I)))

H = new HashTable from idealHash13

M = applyPairs(H, (k,v) -> (trimmedE13_v, k))

"bucket13Hash.m2" << "ideal13Hash = " << toExternalString M << close

end


restart


needsPackage "MultigradedImplicitization"

R = QQ[u_0..u_15]
S = QQ[x_0..x_9, t_1..t_2]

needs "./../params/twoThreeCycleParams.m2"
needs "./../graphs/twoThreeCycleGraphs.m2" 

avoidStructs = {
    {{0,1},{1,2},{0,2},{0,"A"},{1,"B"}} / set,
    {{4,5},{4,6},{5,6},{5,"D"},{6,"E"}} / set
}

trimmedE23 = positions(delete(null,E23), e -> all(avoidStructs, struct -> isSubset(struct, e / set) == false))

IM23 = apply(52, i -> map(S, R, value concatenate("im", toString i)));

idealHash23 = new MutableHashTable from {}

for i from 0 to 51 do (
    
    I := ideal flatten values componentsOfKernel(2,IM23#i);

    if idealHash23#?I then (
        idealHash23#I = idealHash23#I | {i};
    ) else (
        idealHash23#I = {i};
    );
)

apply(keys idealHash23, I -> (isPrime I, dim I, degree I))

apply(keys idealHash23, I -> dim I == rank jacobian matrix map(S,R,value concatenate("im", toString first idealHash23#I)))

H = new HashTable from idealHash23

M = applyPairs(H, (k,v) -> (trimmedE23_v, k))

"bucket23Hash.m2" << "ideal23Hash = " << toExternalString M << close


end

restart


needsPackage "MultigradedImplicitization"

R = QQ[u_0..u_15]
S = QQ[x_0..x_3]

needs "./../params/treeParams.m2"
needs "./../graphs/treeGraphs.m2" 

trimmedETree = toList(0..6)

IMTree = apply(7, i -> map(S, R, value concatenate("im", toString i)));

idealHashTree = new MutableHashTable from {}

for i from 0 to 6 do (
    
    I := ideal flatten values componentsOfKernel(4,IMTree#i);

    if idealHashTree#?I then (
        idealHashTree#I = idealHashTree#I | {i};
    ) else (
        idealHashTree#I = {i};
    );
)

apply(keys idealHashTree, I -> (isPrime I, dim I, degree I))

apply(keys idealHashTree, I -> dim I == rank jacobian matrix map(S,R,value concatenate("im", toString first idealHashTree#I)))

H = new HashTable from idealHashTree

M = applyPairs(H, (k,v) -> (trimmedETree_v, k))

"bucketTreeHash.m2" << "idealTreeHash = " << toExternalString M << close
