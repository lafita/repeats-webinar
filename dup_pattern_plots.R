# Script to plot the duplication pattern and autocorrelation vector of
# protein domain repeats.
#
# Aleix Lafita - June 2018

# Import dependencies
library(ggplot2)
library(dplyr)

# Parse the data file
matrix = read.csv("PF06758_A0A87WZJ2_matrix.tsv", 
                  header = T, sep = "\t", stringsAsFactors = F)

# Duplicate the data to have the complete matrix
matrix = matrix %>%
  mutate(
    domain21 = domain2,
    domain2 = domain1,
    domain1 = domain21
  ) %>% 
  select(-domain21) %>%
  rbind(matrix)

# Set the levels of the domains in the sequential order
levels = unique(matrix$domain2)
matrix = matrix %>%
  mutate(
    domain1 = factor(domain1, levels = levels),
    domain2 = factor(domain2, levels = rev(levels))
  )
  
p = ggplot(matrix, aes(x = domain1, y = domain2, fill = pid)) +
  geom_tile() +
  theme_bw() + theme(
    panel.grid = element_blank(),
    legend.position = "top",
    axis.text.x = element_text(angle = 45, hjust = 1)
  ) +
  scale_fill_gradient(name = "Sequence identity", low = "white", high = "black") +
  xlab("") + ylab("")

pdf("A0A087WZJ2_dup-pattern.pdf", 10, 10)
print(p)
dev.off()

# Assign sequence number to domains
matrix$index1 = match(matrix$domain1, levels)
matrix$index2 = match(matrix$domain2, levels)
matrix$domdist = matrix$index2 - matrix$index1

# Calculate autocorrelation similarity profile
autocorr = matrix %>%
  group_by(domdist) %>%
  summarise(avgpid = mean(pid)) %>%
  filter(domdist >= 0, domdist < max(domdist) / 2)

# Plot the autocorrelation profile
p = ggplot(autocorr, aes(x=domdist, y=avgpid)) +
  geom_line() +
  #geom_hline(yintercept = 0, linetype = 2) +
  theme_bw() + theme(
    panel.grid = element_blank()
  ) + 
  xlab("Domain distance (nr of domains)") + 
  ylab("Mean sequence identity") +
  #ylim(0.5,1) +
  scale_x_continuous(breaks = seq(1, 100, 1))

pdf("A0A087WZJ2_atocorrelation.pdf", 8, 4)
print(p)
dev.off()

