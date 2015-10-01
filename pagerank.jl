

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
# 
function adjacencyMatrix(edges)
	l = maximum(edges) 
	N,_ = size(edges)
	M = sparse(edges[:,1], edges[:,2], ones(N), l, l, max)
end

function edgesToMatrix(edges)
	M = adjacencyMatrix(edges)
	normalizeColumns!(M)
end

function normalizeColumns!(M)
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

function renumber(numberList) 
	numbersappearing = [i for i in Set(numberList)]
	Dict(zip(numbersappearing, 1:length(numbersappearing)))
end



# function normalizeColumns!(M)
# 	(_, c) = size(M)
# 	for i = 1:c
# 		s = sum(M[:,i])
# 		if s ≠ 0
# 			M[:,i] = M[:,i] / s
# 		end
# 	end
# 	M
# end

# function normalizeColumns(M)
# 	Mnew = deepcopy(M)
# 	normalizeColumns!(Mnew)
# end
