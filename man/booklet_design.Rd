% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/booklet_design.R
\name{booklet_design}
\alias{booklet_design}
\title{Assignment of item blocks to test booklets}
\usage{
booklet_design(item_block_assignment, book_design = NULL)
}
\arguments{
\item{item_block_assignment}{a matrix that identifies which items correspond to which block.}

\item{book_design}{a matrix of indicators to assign blocks to booklets.}
}
\description{
\code{block_design} creates a data frame that identifies which items corresponds to which booklets.
}
\section{Details}{

If using \code{booklet_design} in tandem with \code{block_design}, \code{item_block_assignment}
is the the first element of the returned list of \code{block_design}.

The columns of \code{item_block_assignment} represent each block while the rows
represent the number of items in each block.  Because the number of items per
block can vary, the number of rows represents the block with the most items. The
contents of \code{item_block_assignment} is the actual item numbers. The remainder of
shorter blocks are filled with zeros.

The columns of \code{book_design} represent each book while the rows
represent each block.

The default \code{book_design} assigns two blocks to every booklet in a spiral design.
The number of default booklets is equal to the number of blocks and must be >= 3.
If \code{ncol(item_block_assignment)} < 3, \code{book_design} must be specified.
}

\examples{
i_blk_mat <- matrix(seq(1:40), ncol = 5)
blk_book <- matrix(c(1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1,
                     0, 0, 0, 1, 1, 0, 1, 1, 0, 0, 1, 0, 0, 1, 0),
                     ncol = 5, byrow = TRUE)
booklet_design(item_block_assignment = i_blk_mat, book_design = blk_book)
booklet_design(item_block_assignment = i_blk_mat)

}
