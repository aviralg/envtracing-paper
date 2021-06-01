library(tidyverse)
library(ggplot2)
library(fst)
library(fs)
library(DT)
library(tibble)
library(scales)
library(tikzDevice)
library(viridis)
library(RColorBrewer)

new_theme <-
    theme_minimal(base_size = 8) +
    theme(plot.margin = margin(0.1,0.25,0.1,0.2, "cm"))
          #plot.background = element_rect(colour = "black", fill=NA, size=1))

old_theme <- theme_set(new_theme)

read_any <- function(filepath) {
    ext <- path_ext(filepath)
    if(ext == "fst") {
        read_fst(filepath)
    }
    else if(ext == "csv") {
        read_csv(filepath)
    }
    else {
        read_lines(filepath)
    }
}

read_lazy <- function(var, filename) {
    filepath <- path_join(c(params$datadir, filename))
    eval_env <- environment()
    assign_env <- parent.frame()
    delayedAssign(as.character(substitute(var)),
                  read_any(print(filepath)),
                  eval_env,
                  assign_env)
}

compute_percentage <- function(n, precision) {
    round( (n * 100) / sum(n) , precision)
}

show_table <- function(df) {
    datatable(df)
}

save_graph <- function(plot, filename, width = 5.4, height = 1.8, ...) {
    dir_create(params$graphdir)
    filepath <- path_ext_set(path_join(c(params$graphdir, filename)), "tex")
    tikz(file = filepath, sanitize=TRUE, width=width, height=height, ...)
    print(plot)
    dev.off()
    plot
}

as_perc <- function(col) {
    paste(col, "\\%", sep = "")
}

as_tex_table <- function(rows, filename, dir) {
    str <- paste(paste0(rows, "\\\\"), collapse = "\n")
    cat(str)
    str
}

read_lazy(allocation, "allocation.fst")
read_lazy(execution, "execution.fst")
read_lazy(env_class, "env_class.fst")
read_lazy(env_cons, "env_cons.fst")

# read_lazy <-
#     arg_ref %>%
#     filter(pack_name %in% corpus) %>%
#     filter(is.na(source_pack_name) | source_pack_name %in% corpus)
# 
# parameters <-
#     parameters %>%
#     filter(pack_name %in% corpus)
# 
# metaprogramming <-
#     metaprogramming %>%
#     filter(source_pack_name %in% corpus) %>%
#     filter(pack_name %in% corpus)
# 
# functions <-
#     functions %>%
#     filter(pack_name %in% corpus)
# 
# argument_type <-
#     argument_type %>%
#     filter(pack_name %in% corpus)
# 
# direct_effects <-
#     direct_effects %>%
#     filter(pack_name %in% corpus)
# 
# indirect_effects <-
#     indirect_effects %>%
#     filter(pack_name %in% corpus)
