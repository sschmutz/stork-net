library(tidyverse)
library(here)

# with this script, the labeled images are sorted into folders
# 2019_train/train/stork/ and 2019_train/train/no_stork/ are the training sets
# 2019_train/validation/stork/ and 2019_train/validation/no_stork/ are the validation sets
# 2019_test/ ist the test set

# in the end there should be 60 test images, 340 training images (of which 60 are to validate, and 280 are to train)

# the datastructure follows roughly the one used in this tutorial:
# https://www.tensorflow.org/tutorials/images/classification

# of all the labeled images 85% were sampled for the training set
# it was not considered if a stork is present or not (no stratified sampling)
# during training 15% of those 85% will be used as validation set
ratio_train <- 0.85

# of the training set, 17.6% can be used for validation
ratio_validate <- 0.177

# to make it reproducible, a seed was set
set.seed(20200505)


labeled <-
  read_csv(here("images", "files_2019_sampled_labeled.csv"))

labeled_train <-
  labeled %>%
  sample_n(nrow(labeled) * ratio_train)

labeled_validation <-
  labeled_train %>%
  sample_n(nrow(labeled_train) * ratio_validate)

labeled <-
  labeled %>%
  mutate(train = if_else(filename %in% labeled_train$filename, 1, 0),
         validation = if_else(filename %in% labeled_validation$filename, 1, 0))

# overwrite the csv file with the updated version which contains an additional column (train yes or no)
write_csv(labeled, here("images", "files_2019_sampled_labeled.csv"))


# filter for the samples which should be copied into the individual folders
train_stork <-
  labeled %>%
  filter(train == 1,
         validation == 0,
         stork_present == 1)

train_no_stork <-
  labeled %>%
  filter(train == 1,
         validation == 0,
         stork_present == 0)

validation_stork <-
  labeled %>%
  filter(train == 1,
         validation == 1,
         stork_present == 1)

validation_no_stork <-
  labeled %>%
  filter(train == 1,
         validation == 1,
         stork_present == 0)

test <-
  labeled %>%
  filter(train == 0)


# copy the files into the respective folders (the original images were kept)
# train
file.copy(from = here("images", "2019_sampled", train_stork$filename),
          to = here("images", "2019_train", "train", "stork", train_stork$filename))

file.copy(from = here("images", "2019_sampled", train_no_stork$filename),
          to = here("images", "2019_train", "train", "no_stork", train_no_stork$filename))

# validation
file.copy(from = here("images", "2019_sampled", validation_stork$filename),
          to = here("images", "2019_train", "validation", "stork", validation_stork$filename))

file.copy(from = here("images", "2019_sampled", validation_no_stork$filename),
          to = here("images", "2019_train", "validation", "no_stork", validation_no_stork$filename))

# test
file.copy(from = here("images", "2019_sampled", test$filename),
          to = here("images", "2019_test", test$filename))


