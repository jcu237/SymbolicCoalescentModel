updateHash = method(TypicalValue => HashTable)

-- updates edge hash after finding parental networks
updateHash(Thing, HashTable, Digraph) := (hybrid, oldEdgeHash, speciesNetwork) -> (

    if member(-hybrid-10, vertices speciesNetwork) then (
        v := last sort toList parents(speciesNetwork, -hybrid-10);
        return new HashTable from (apply(keys oldEdgeHash, k -> k => oldEdgeHash#k) | {{v, -hybrid-10} => oldEdgeHash#{v,hybrid}})
    ) else (
        return oldEdgeHash
    )
)

-- updates hybrid hash after finding parental networks
updateHash(Thing, HashTable) := (hybrid, oldHybridHash) -> (
    K := delete(hybrid, keys oldHybridHash);
    return new HashTable from apply(K, k -> k => oldHybridHash#k)
)
