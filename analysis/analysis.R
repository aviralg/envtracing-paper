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
          #axis.text.x = element_text(family = "LinuxLibertineT-TLF"),
          #axis.text.y = element_text(family = "LinuxLibertineT-TLF"))
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

compute_proportion <- function(n, precision) {
    round(n / sum(n), precision)
}

show_table <- function(df) {
    datatable(df)
}

save_graph <- function(plot, filename, width = 3.3, height = 1.5, ...) {
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

as_tex_table <- function(rows) {
    str <- paste(paste0(rows, "\\\\"), collapse = "\n")
    cat(str)
    str
}

split_qual_name <- function(qual_name) {
    split <- str_split(qual_name, fixed(NAME_SEPARATOR))

    joiner <- function(names) {
        paste(names[2:length(names)], sep = "", collapse = "::")
    }

    tibble(pack_name = unlist(map(split, ~.[1])),
           fun_name = unlist(map(split, joiner(.))))
}

read_lazy(extract_index, "extract-index.fst")
read_lazy(package_info, "package-info.fst")
read_lazy(sloc_script, "corpus-sloc.fst")
read_lazy(sloc_package, "package-sloc.fst")
read_lazy(package_table, "package-table.fst")
read_lazy(corpus, "corpus")
read_lazy(client, "client")
read_lazy(functions, "functions.fst")
read_lazy(allocation, "allocation.fst")
read_lazy(execution, "execution.fst")
read_lazy(env_class, "env_class.fst")
read_lazy(new_env, "new_env.fst")
read_lazy(call_event_seq, "call_event_seq.fst")

sloc_script %<>%
    mutate(package2 = type) %>%
    mutate(type = package) %>%
    mutate(package = package2)

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
