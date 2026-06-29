needsPackage "MultigradedImplicitization"

R = QQ[u_0..u_15]
S = QQ[x_0..x_6,t_1]

needs "../params/fiveCycleParams.m2"
needs "../graphs/fiveCycleGraphs.m2"
k = #delete(null, E5)

IM5 = apply(k, i -> map(S, R, value concatenate("im", toString i)));

ideal5Hash = new MutableHashTable from {}

for i from 0 to k-1 do (

    I := ideal flatten values componentsOfKernel(4, IM5#i);

    if ideal5Hash#?I then (
        ideal5Hash#I = ideal5Hash#I | {i};
    ) else (
        ideal5Hash#I = {i};
    );
)

M = applyPairs(new HashTable from ideal5Hash, (k,v) -> (v,k))

"bucket5Hash.m2" << "ideals5Hash = " << toExternalString M << close

end

-----------------------
-- Analysis
-----------------------

restart
needsPackage "Graphs"
needsPackage "Matroids"

R = QQ[u_0..u_15]
S = QQ[x_0..x_6,t_1]

needs "../params/fiveCycleParams.m2"
needs "../graphs/fiveCycleGraphs.m2"
needs "bucket5Hash.m2"

networks = delete(null, E5) / digraph
buckets5 = keys ideals5Hash

----------
-- {4,5}
----------
I = ideals5Hash#{4,5}
f4 = map(S,R,im4);
f5 = map(S,R,im5);
apply({f4,f5}, f -> rank jacobian matrix f)
dim I, degree I

-- not full ideal, need matroids
U = support(basis(1,R) % I)
RU = QQ[U]
fU4 = map(S,RU,im4_(U / index))
fU5 = map(S,RU,im5_(U / index))
M4 = matroid jacobian matrix fU4
M5 = matroid jacobian matrix fU5
M4 == M5

select(circuits M5, C -> member(C, circuits M4) == false)

C = {6,8,9,10,11,13}
rank((jacobian matrix f4)_C)
rank((jacobian matrix f5)_C)


----------
-- {0}
----------
I = ideals5Hash#{0}
f0 = map(S,R,im0);
rank jacobian matrix f0
dim I, degree I
isPrime I
tally((flatten entries gens I) / degree)

----------
-- {1}
----------
I = ideals5Hash#{1}
f1 = map(S,R,im1)
rank jacobian matrix f1
dim I, degree I
isPrime I
tally((flatten entries gens I) / degree)

----------
-- {2}
----------
I = ideals5Hash#{2};
f2 = map(S,R,im2);
rank jacobian matrix f2
dim I, degree I
isPrime I
tally((flatten entries gens I) / degree)

----------
-- {3}
----------
I = ideals5Hash#{3};
f3 = map(S,R,im3);
rank jacobian matrix f3
dim I, degree I
isPrime I
tally((flatten entries gens I) / degree)

----------
-- {6}
----------
I = ideals5Hash#{6};
f6 = map(S,R,im6);
rank jacobian matrix f6
dim I, degree I

-- not full ideal
U = support(basis(1,R) % I)
RU = QQ[U]
fU6 = map(S, RU, im6_(U / index))
IU6 = ker fU6

dim IU6, degree IU6
tally((flatten entries gens IU6) / degree)

----------
-- {7,8}
----------
I = ideals5Hash#{7,8}
f7 = map(S,R,im7);
f8 = map(S,R,im8);
apply({f7,f8}, f -> rank jacobian matrix f)
dim I, degree I
tally((flatten entries gens I) / degree)


-- not equal, need matroids
U = support(basis(1,R) % I)
RU = QQ[U]
fU7 = map(S,RU,im7_(U / index))
fU8 = map(S,RU,im8_(U / index))

M7 = matroid jacobian matrix fU7
M8 = matroid jacobian matrix fU8

C = {1,3,5,6,8,9}
rank((jacobian matrix f7)_C)
rank((jacobian matrix f8)_C)
