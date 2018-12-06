
inc <- function(x) {

    eval.parent(substitute(x <- x + 1))
}

dec <- function(x) {

    eval.parent(substitute(x <- x - 1))
}