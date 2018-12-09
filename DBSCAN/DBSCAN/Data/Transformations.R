
preprocessDataset <- function(D) {

    idSeq = as.data.frame(seq(1, dim(D)[1], 1))

    label = as.data.frame(rep(0, dim(D)[1]))

    colnames(idSeq) = c("id")

    colnames(label) = c("label")

    D = cbind(idSeq, D)

    D = cbind(D, label)

    D
}


inc <- function(x) {

    eval.parent(substitute(x <- x + 1))
}

dec <- function(x) {

    eval.parent(substitute(x <- x - 1))
}