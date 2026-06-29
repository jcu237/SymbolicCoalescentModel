R = QQ[u_0..u_15]

needs "bucket13Hash.m2"
needs "bucket23Hash.m2"
needs "bucketTreeHash.m2"

idealTreeHash
ideal13Hash
ideal23Hash

-- no tree ideals appear in the other hash tables
any(values idealTreeHash, I -> member(I, values ideal13Hash))
any(values idealTreeHash, I -> member(I, values ideal23Hash))

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
-- {128,129,130,131,132,135,139,140,141,144,148,149,150,151,152,153,154,155,160,164,165,166,171,175,176,177}
---- these are the graphs where
------ there are 2 3-cycles, one at the central internal vertex and one on the D-E cherry
------ the root is either on the D-E cherry 3-cycle or on the edge pendant to D or on the edge pendant to E
----------------

I1 = ideal13Hash#{25,26,34,35}
I1 == ideal23Hash#{128,129,130,131,132,135,139,140,141,144,148,149,150,151,152,153,154,155,160,164,165,166,171,175,176,177}

----------------
-- {30,31,39,40}
---- these are the graphs where 
------ there is 1 3-cycle at the central internal vertex
------ the root is on the pendant edge to D or the pendant edge to E
--{7,12,13,14,18,21,22,23,34,39,40,41,45,48,49,50,54,55,56,57,58,59,60,61,62,63}
---- these are the graphs where
------ there are 2 3-cycles, one at the central vertex and one on the A-B cherry
------ the root is either on the A-B cherry 3-cycle or on the edge pendant to D or on the edge pendant to E
-----------------

I2 = ideal13Hash#{30,31,39,40}
I2 == ideal23Hash#{7,12,13,14,18,21,22,23,34,39,40,41,45,48,49,50,54,55,56,57,58,59,60,61,62,63}


--------------------------------------------------

needs "bucket4Hash.m2"
needs "bucket34Hash.m2"

ideal4Hash
ideal34Hash

-- there are no repeats here, so we know they are all distinct.
any(values ideal4Hash, I -> member(I, values ideal34Hash))

