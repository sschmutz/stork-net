library(tidyverse)
library(here)

# with this script, the labeled images are sorted into folders
# 2019_train/stork/ and 2019_train/no_stork/ are the training sets
# 2019_test/ ist the test set

# of all the labeled images 75% were sampled for the training set
# it was not considered if a stork is present or not (no stratified sampling)
ratio_train <- 0.75

# to make it reproducible, a seed was set
set.seed(20200505)


labeled <-
  read_csv(here("images", "files_2019_sampled_labeled.csv"))

labeled_train <-
  labeled %>%
  sample_n(nrow(labeled) * ratio_train)

labeled <-
  labeled %>%
  mutate(train = if_else(filename %in% labeled_train$filename, 1, 0))

# overwrite the csv file with the updated version which contains an additional column (train yes or no)
write_csv(labeled, here("images", "files_2019_sampled_labeled.csv"))


# filter for the samples which should be copied into the individual folders
train_stork <-
  labeled %>%
  filter(train == 1,
         stork_present == 1)

train_no_stork <-
  labeled %>%
  filter(train == 1,
         stork_present == 0)

test <-
  labeled %>%
  filter(train == 0)


# copy the files into the respective folders (the original images were kept)
file.copy(from = here("images", "2019_sampled", train_stork$filename),
          to = here("images", "2019_train", "stork", train_stork$filename))

file.copy(from = here("images", "2019_sampled", train_no_stork$filename),
          to = here("images", "2019_train", "no_stork", train_no_stork$filename))


file.copy(from = here("images", "2019_sampled", test$filename),
          to = here("images", "2019_test", test$filename))


