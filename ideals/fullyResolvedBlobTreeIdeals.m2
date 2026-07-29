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

-- check whether all ideals are prime, compute dimension and degree
apply(keys idealHash13, I -> (isPrime I, dim I, degree I))

-- check ideals have correct dimension, verifying we have full ideals
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

-- verify all ideals are prime, compute dimension and degree
apply(keys idealHash23, I -> (isPrime I, dim I, degree I))

-- verify all ideals have correct dimension, so full ideal is found
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
    
    --I := ideal flatten values componentsOfKernel(4,IMTree#i);
    I := ker IMTree#i;
    if idealHashTree#?I then (
        idealHashTree#I = idealHashTree#I | {i};
    ) else (
        idealHashTree#I = {i};
    );
)

-- verify all found ideals are prime, compute dim and degree
apply(keys idealHashTree, I -> (isPrime I, dim I, degree I))

-- verify we have correct dimension, so full ideal is found
apply(keys idealHashTree, I -> dim I == rank jacobian matrix map(S,R,value concatenate("im", toString first idealHashTree#I)))

H = new HashTable from idealHashTree

M = applyPairs(H, (k,v) -> (trimmedETree_v, k))

"bucketTreeHash.m2" << "idealTreeHash = " << toExternalString M << close

end



-----------------------
-- Analysis
-----------------------
restart
R = QQ[u_0..u_15]

needs "bucket13Hash.m2"
needs "bucket23Hash.m2"
needs "bucketTreeHash.m2"

idealTreeHash
ideal13Hash
ideal23Hash

-- no tree ideals appear in the other hash tables
all(values idealTreeHash, I -> member(I, values ideal13Hash) == false)
all(values idealTreeHash, I -> member(I, values ideal23Hash) == false)

-- there are two ideals which appear for both the 2 3-cycle graphs and 1 3-cycle graphs 
any(values ideal13Hash, I -> member(I, values ideal23Hash))
select(keys ideal13Hash, k -> member(ideal13Hash#k, values ideal23Hash))

needs "./../graphs/threeCycleGraphs.m2"
needs "./../graphs/twoThreeCycleGraphs.m2"

----------------
-- {25,26,34,35}
---- these are the graphs where
------ there is 1 3-cycle at the central internal vertex
------ the root is on the edge pendant to D or the edge pendant to E
------ {N_4(v_9), N_4(v_10)}
-- {128,129,130,131,132,135,139,140,141,144,148,149,150,151,152,153,154,155,160,164,165,166,171,175,176,177}
---- these are the graphs where
------ there are 2 3-cycles, one at the central internal vertex and one on the D-E cherry
------ the root is either on the D-E cherry 3-cycle or on the edge pendant to D or on the edge pendant to E
------ {N_5(v_i) : 1 <= i <= 5}
----------------

I1 = ideal13Hash#{25,26,34,35}
I1 == ideal23Hash#{128,129,130,131,132,135,139,140,141,144,148,149,150,151,152,153,154,155,160,164,165,166,171,175,176,177}

----------------
-- {30,31,39,40}
---- these are the graphs where 
------ there is 1 3-cycle at the central internal vertex
------ the root is on the pendant edge to A or the pendant edge to B
------ {N_4(v_1), N_4(v_2)}
--{7,12,13,14,18,21,22,23,34,39,40,41,45,48,49,50,54,55,56,57,58,59,60,61,62,63}
---- these are the graphs where
------ there are 2 3-cycles, one at the central vertex and one on the A-B cherry
------ the root is either on the A-B cherry 3-cycle or on the edge pendant to D or on the edge pendant to E
------ {N_6(v_i) : 1 <= i <= 5}
-----------------

I2 = ideal13Hash#{30,31,39,40}
I2 == ideal23Hash#{7,12,13,14,18,21,22,23,34,39,40,41,45,48,49,50,54,55,56,57,58,59,60,61,62,63}


