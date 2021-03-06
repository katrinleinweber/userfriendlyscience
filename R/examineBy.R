examineBy <- function(..., by=NULL, stem=TRUE, plots=TRUE,
                      extremeValues = 5, descr.include=NULL,
                      qqCI=TRUE, conf.level=.95) {

  if (is.null(by)) {
    stop("You have to specify a 'by' argument. If you don't want to ",
         "order descriptives organised by another variable, use 'examine'.");
  }
  
  if (length(list(...)) == 1) {
    dat <- list(...)[[1]];
    if (is.data.frame(dat)) {
      varNames <- names(dat);
    } else {
      varNames <- unlist(as.list(substitute(list(...)))[-1]);
    }
  } else {
    if (length(unique(unlist(lapply(list(...), length)))) != 1) {
      stop("The vectors that were provided has unequal lengths ",
           "(specifically, ", vecTxt(lapply(list(...), length)), ").");
    }
    dat <- list(...);
    varNames <- unlist(as.list(substitute(list(...)))[-1]);
  }

  dat <- as.data.frame(dat);
  names(dat) <- extractVarName(varNames);

  res <- dlply(dat, as.quoted(~by), examine,
               stem=stem, plots=plots,
               extremeValues=extremeValues,
               descr.include=descr.include,
               qqCI=qqCI, conf.level=conf.level);

  class(res) <- 'examineBy';

  return(res);
  
}

print.examineBy <- function(x, ...) {
  
  for (examineObjects in 1:length(x)) {
    cat0(repStr("#", 60), "\n");
    cat0(extractVarName(names(x)[examineObjects]), "\n");
    cat0(repStr("#", 60), "\n\n");
    print(x[[examineObjects]]);
  }

}

pander.examineBy <- function(x, headerPrefix = "",
                             headerStyle = "**",
                             secondaryHeaderPrefix = "",
                             secondaryHeaderStyle="*",
                             tertairyHeaderPrefix = "--> ",
                             tertairyHeaderStyle="",
                             separator = paste0("\n\n", repStr("-", 10), "\n\n"),
                             ...) {
  
  for (examineObjects in 1:length(x)) {
    cat("\n");
    if (examineObjects > 1)
      cat0(separator);
    cat0(headerPrefix, headerStyle,
         extractVarName(names(x)[examineObjects]),
         headerStyle);
    pander(x[[examineObjects]],
           headerPrefix=secondaryHeaderPrefix,
           headerStyle=secondaryHeaderStyle,
           secondaryHeaderPrefix=tertairyHeaderPrefix,
           secondaryHeaderStyle=tertairyHeaderStyle);
  }
  
}
