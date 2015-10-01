#

### Pagerank

# Compute the pagerank for: 
# the transition matrix M
# Random teleport probability 1 - β
# Threshold ε
function pagerank(M, β, ε)
	_, c = size(M)
	lOne(a,b) = sum(abs(a-b))
	rprev = ones(c)
	rnew = ones(c) / c
	while lOne(rprev,rnew) > ε
		rprev = rnew
		rnew = singleIteration(M, rprev, β)
	end
	rnew
end

# Inner loop for pagerank
function singleIteration(M, r, β)
	rnew = β * M * r
	e = ones(size(r))
	rnew + (1 - sum(rnew)) / length(r) * e
end



# edges = 2 column matrix with values from [1, number_of_pages]
# so that _all_ values show up.
# If [a b] is a row, then there should be an edge a → b
function transitionMatrix(edges)
	l = maximum(edges) 
	N,_ = size(edges)
	M = sparse(edges[:,2], edges[:,1], ones(N), l, l, max)
	normalizeColumns!(M)
end

function normalizeColumns!(M::SparseMatrixCSC)
# Here M should be a sparse matrix
	vals = nonzeros(M)
	_, c = size(M)
	for i = 1:c
		S = sum(vals[nzrange(M,i)])
		if S ≠ 0
			vals[nzrange(M,i)] = vals[nzrange(M,i)] / S
		end
	end
	M
end



# Helper functions
# If the set of nodes is not named from elements [1, number_of_pages]
# then we need a correspondence between that set & and the set of 
# names of nodes.

function intLabels(nodesList) 
	numbers = [i for i in Set(nodesList)]
	Dict(zip(numbers, 1:length(numbers)))
end

function wrappedpagerank(data, β, ε)
	fi = intLabels(data)
	edges = map((x) -> fi[x], data)
	M = transitionMatrix(edges)
	r = pagerank(M, β, ε)
	(Int=>Float64)[key => r[fi[key]] for key in keys(fi)]
end

