----------------------------------
-- Get ideals up to degree 4
----------------------------------

needsPackage "MultigradedImplicitization"

R = QQ[u_0..u_15]
S = QQ[x_0..x_6,t_1]

needs "../graphs/fourCycleGraphs.m2"
needs "../params/fourCycleParams.m2"

E4Trimmed = delete(null, E4);

IM4 = apply(34, i -> map(S, R, value concatenate("im", toString i)));

ideal4Hash = new MutableHashTable from {}

for i from 0 to 33 do (
    
    I := ideal flatten values componentsOfKernel(4, IM4#i);

    if ideal4Hash#?I then (
        ideal4Hash#I = ideal4Hash#I | {i};
    ) else (
        ideal4Hash#I = {i};
    );
)

H = new HashTable from ideal4Hash

M = applyPairs(H, (k,v) -> (v,k)); 

"bucket4Hash.m2" << "ideal4Hash = " << toExternalString M << close
end

restart
needsPackage "MultigradedImplicitization"

R = QQ[u_0..u_15]
S = QQ[x_0..x_9,t_1..t_2]

needs "../graphs/threeAndFourCycleGraphs.m2"
needs "../params/threeAndFourCycleParams.m2"

avoidStructs = {
    {{4,5},{4,6},{5,6},{5,"D"},{6,"E"}} / set
}

trimmedE34 = positions(delete(null, E34), e -> all(avoidStructs, struct -> isSubset(struct, e / set) == false))

IM34 = apply(39, i -> map(S, R, value concatenate("im", toString i)));

ideal34Hash = new MutableHashTable from {}

for i from 0 to 38 do (

    I := ideal flatten values componentsOfKernel(3, IM34#i);

    if ideal34Hash#?I then (
        ideal34Hash#I = ideal34Hash#I | {i};
    ) else (
        ideal34Hash#I = {i};
    );
)

H = new HashTable from ideal34Hash

M = applyPairs(H, (k,v) -> (v,k));

"bucket34Hash.m2" << "ideal34Hash = " << toExternalString M << close


end

















--------------------------
-- Analysis for 4-cycle
---------------------------
restart
needsPackage "Visualize"
openPort "8080"

R = QQ[u_0..u_15]
S = QQ[x_0..x_6,t_1]

needs "../graphs/fourCycleGraphs.m2"
needs "../params/fourCycleParams.m2"
needs "bucket4Hash.m2"


buckets4 = keys ideal4Hash

----------------
-- {9,14,17}
-- {N_8(v_1), N_8(v_6), N_8(v_7)}
----------------
f9 = map(S,R,im9);
f14 = map(S,R,im14);
f17 = map(S,R,im17);

apply({f9,f14,f17}, f -> rank jacobian matrix f)
I = ideal4Hash#{9,14,17}
(dim I, degree I)
isPrime I
tally((flatten entries gens I) / degree)


----------------
-- {25, 26}
-- {N_9(v_6), N_9(v_9)}
----------------
f25 = map(S,R,im25)
f26 = map(S,R,im26)

apply({f25,f26}, f -> rank jacobian matrix f)
I = ideal4Hash#{25,26}
(dim I, degree I)
tally((flatten entries gens I) / degree)
-- dimension is too large, missing generators

-- reduce by linear invariants
U = support(basis(1,R) % ideal(select(flatten entries gens I, f -> degree f == {1})))
RU = QQ[U]
fU25 = map(S,RU,im25_(U / index))
fU26 = map(S,RU,im26_(U / index))
I25 = ker fU25
I26 = ker fU26
tally((flatten entries gens I25) / degree)
tally((flatten entries gens I26) / degree)

---------------
-- {11}
-- {N_8(v_10)}
---------------
f11 = map(S,R,im11)
rank jacobian matrix f11
I = ideal4Hash#{11}
(dim I, degree I)
isPrime I
tally((flatten entries gens I) / degree)

--------------
-- {12}
-- {N_8(v_4)}
--------------
f12 = map(S,R,im12)
rank jacobian matrix f12
I = ideal4Hash#{12}
(dim I, degree I)
isPrime I
tally((flatten entries gens I) / degree)

--------------
-- {13}
-- {N_8(v_5)}
--------------
f13 = map(S,R,im13)
rank jacobian matrix f13
I = ideal4Hash#{13}
(dim I, degree I)
isPrime I
tally((flatten entries gens I) / degree)

--------------
-- {10,15,16}
-- {N_8(v_3), N_8(v_8), N_8(v_9)}
--------------
f10 = map(S,R,im10);
f15 = map(S,R,im15);
f16 = map(S,R,im16);

apply({f10,f15,f16}, f -> rank jacobian matrix f)
I = ideal4Hash#{10,15,16}
(dim I, degree I)
isPrime I
tally((flatten entries gens I) / degree)

-------------
-- {18}
-- {N_9(v_1)}
-------------
f18 = map(S,R,im18)
rank jacobian matrix f18
I = ideal4Hash#{18}
(dim I, degree I)
isPrime I
tally((flatten entries gens I) / degree)

-------------
-- {19} -- cant verify degree
-- {N_9(v_2)}
-------------
f19 = map(S,R,im19)
rank jacobian matrix f19
I = ideal4Hash#{19}
(dim I, degree I)
tally((flatten entries gens I) / degree)

-------------
-- {20}
-- {N_9(v_10)}
-------------
f20 = map(S,R,im20); 
rank jacobian matrix f20
I = ideal4Hash#{20}
(dim I, degree I)
isPrime I
tally((flatten entries gens I) / degree)

--------------
-- {21}
-- {N_9(v_4)}
--------------
f21 = map(S,R,im21);
rank jacobian matrix f21
I = ideal4Hash#{21}
(dim I, degree I)
isPrime I
tally((flatten entries gens I) / degree)

--------------
-- {22}
-- {N_9(v_5)}
--------------
f22 = map(S,R,im22);
rank jacobian matrix f22
I = ideal4Hash#{22}
(dim I, degree I)
isPrime I
tally((flatten entries gens I) / degree)

-------------
-- {7,8}
-- {N_7(v_6), N_7(v_9)}
-------------
f7 = map(S,R,im7);
f8 = map(S,R,im8);
apply({f7,f8}, f -> rank jacobian matrix f)
I = ideal4Hash#{7,8}
dim I
tally((flatten entries gens I) / degree)

-- dimension too large
U = support(basis(1,R) % I)
RU = QQ[U]
fU7 = map(S,RU,im7_(U / index))
fU8 = map(S,RU,im8_(U / index))
IU7 = ker fU7
IU8 = ker fU8
degree IU7
degree IU8
tally((flatten entries gens IU7) / degree)
tally((flatten entries gens IU8) / degree)

-------------
-- {23,24}
-- {N_9(v_7), N_9(v_8)}
-------------
f23 = map(S,R,im23)
f24 = map(S,R,im24)
apply({f23,f24}, f -> rank jacobian matrix f)
I = ideal4Hash#{23,24}
(dim I, degree I)
tally((flatten entries gens I) / degree)

-- dimension too large, reducing by linears doesnt help with GB, but does with matroids
needsPackage "Matroids" 

U = support(basis(1,R) % I)
RU = QQ[U]
fU23 = map(S,RU,im23_(U / index))
fU24 = map(S,RU,im24_(U / index))
M23 = matroid jacobian matrix fU23
M24 = matroid jacobian matrix fU24
M23 == M24
select(circuits M23, C -> member(C, circuits M24) == false)
select(circuits M24, C -> member(C, circuits M23) == false)

rank((jacobian matrix f23)_{1,3,4,6,10,11})
rank((jacobian matrix f24)_{1,3,4,6,10,11})

------------
-- {0}
-- {N_7(v_2)}
------------
f0 = map(S,R,im0);
rank jacobian matrix f0
I = ideal4Hash#{0};
(dim I, degree I)
isPrime I
tally((flatten entries gens I) / degree)

------------
-- {1}
-- {N_7(v_3)}
------------
f1 = map(S,R,im1);
rank jacobian matrix f1
I = ideal4Hash#{1};
(dim I, degree I)
isPrime I
tally((flatten entries gens I) / degree)

-------------
-- {2}
-- {N_7(v_10)}
-------------
f2 = map(S,R,im2);
rank jacobian matrix f2
I = ideal4Hash#{2};
(dim I, degree I)
isPrime I
tally((flatten entries gens I) / degree)

---------------
-- {5,6}
-- {N_7(v_7), N_7(v_8)}
---------------
f5 = map(S,R,im5);
f6 = map(S,R,im6);
apply({f5,f6}, f -> rank jacobian matrix f)
I = ideal4Hash#{5,6};
(dim I, degree I)
tally((flatten entries gens I) / degree)

-- again need matroids
U = support(basis(1,R) % I)
RU = QQ[U]
fU5 = map(S,RU,im5_(U/index))
fU6 = map(S,RU,im6_(U/index))
M5 = matroid jacobian matrix fU5
M6 = matroid jacobian matrix fU6
M5 == M6
select(circuits M5, C -> member(C, circuits M6) == false)
select(circuits M6, C -> member(C, circuits M5) == false)

rank((jacobian matrix f5)_{4,6,10,11,12,13})
rank((jacobian matrix f6)_{4,6,10,11,12,13})

----------------
-- {3}
-- {N_7(v_4)} 
----------------
f3 = map(S,R,im3);
rank jacobian matrix f3
I = ideal4Hash#{3};
(dim I, degree I)
isPrime I
tally((flatten entries gens I) / degree)

---------------
-- {4}
-- {N_7(v_5)}
---------------
f4 = map(S,R,im4);
rank jacobian matrix f4
I = ideal4Hash#{4};
(dim I, degree I)
isPrime I
tally((flatten entries gens I) / degree)

end
restart

---------------------------
-- {27,28,29,30,31,32,33}
-- {N_10(v_1), N_10(v_2), N_10(v_3), N_10(v_6), N_10(v_7), N_10(v_8), N_10(v_9)}
---------------------------
needsPackage "NumericalImplicitization"

R = CC[u_0..u_15]
S = CC[x_0..x_6,t_1]


needs "../params/fourCycleParams.m2"
needs "bucket4Hash.m2"

f27 = map(S,R,im27);
f28 = map(S,R,im28);
f29 = map(S,R,im29);
f30 = map(S,R,im30);
f31 = map(S,R,im31);
f32 = map(S,R,im32);
f33 = map(S,R,im33);

I = ideal4Hash#{27,28,29,30,31,32,33}
U = support(basis(1,R) % I)
RU = QQ[U]
fU27 = map(S,RU,im27_(U / index));
fU28 = map(S,RU,im28_(U / index));
fU29 = map(S,RU,im29_(U / index));
fU30 = map(S,RU,im30_(U / index));
fU31 = map(S,RU,im31_(U / index));
fU32 = map(S,RU,im32_(U / index));
fU33 = map(S,RU,im33_(U / index));
apply({fU27, fU28, fU29, fU30, fU31, fU32, fU33}, f -> numericalImageDegree(f,ideal 0_S))
apply({fU27, fU28, fU29, fU30, fU31, fU32, fU33}, f -> numericalImageDim(f,ideal 0_S))

end















-------------------------------
-- Analysis for 3- and 4-cycles
-------------------------------
restart

R = QQ[u_0..u_15]
S = QQ[x_0..x_9,t_1,t_2]

needs "../params/threeAndFourCycleParams.m2"
needs "bucket34Hash.m2"

buckets34 = keys ideal34Hash


-----------------------------
-- {26,27,28,29,30,31,32,33,34,35,36,37,38}
-- {N_13(v_1), N_13(v_2), N_13(v_3)} -- have 3 possible hybrid locations in 3-cycle
-- {N_13(v_4), N_13(v_5)} -- have 2 possible hybrid locations in 3-cycle
-- these have hybrid ancestral to C
-----------------------------
f0 = apply(buckets34#0, i -> map(S, R, value concatenate("im", toString i)));
apply(f0, f -> rank jacobian matrix f)
I = ideal34Hash#(buckets34#0)
(dim I, degree I)
isPrime I
tally((flatten entries gens I) / degree)


----------------------------
-- {0,1,2,3,4,5,6,7,8,9,10,11,12}
-- {N_11(v_1), N_11(v_2), N_11(v_3)} -- have 3 possible hybrid locations in 3-cycle
-- {N_11(v_4), N_11(v_5)} -- have 2 possible hybrid locations in 3-cycle
-- these have hybrid ancestral to A
----------------------------
f1 = apply(buckets34#1, i -> map(S, R, value concatenate("im", toString i)));
apply(f1, f -> rank jacobian matrix f)
I = ideal34Hash#(buckets34#1)
(dim I, degree I)
isPrime I
tally((flatten entries gens I) / degree)

----------------------------
-- {13,14,15,16,17,18,19,20,21,22,23,24,25}
-- {N_12(v_1), N_12(v_2), N_12(v_3)} -- have 3 possible hybrid locations in 3-cycle
-- {N_12(v_4), N_12(v_5)} -- have 2 possible hybrid locations in 3-cycle
-- these have hybrid ancestral to B
----------------------------
f2 = apply(buckets34#2, i -> map(S, R, value concatenate("im", toString i)));
apply(f2, f -> rank jacobian matrix f)
I = ideal34Hash#(buckets34#2)
(dim I, degree I)
isPrime I
tally((flatten entries gens I) / degree)

end
