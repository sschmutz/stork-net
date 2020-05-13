library(tidyverse)
library(here)

# with this script, the labeled images are sorted into folders
# 2019_train/train/0_stork/, 1_stork/, 2_stork/, 3_stork/ are the training sets
# 2019_train/validation/0_stork/, 1_stork/, 2_stork/, 3_stork/  are the validation sets
# 2019_test/ ist the test set

# in the end there should be 441 test images, 2499 training images (of which 442 are to validate, and 2057 are to train)

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
  read_csv(here("images", "files_2019_sampled_labeled.csv")) %>%
  filter(!is.na(stork_number))

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
train_0_stork <-
  labeled %>%
  filter(train == 1,
         validation == 0,
         stork_number == 0)

train_1_stork <-
  labeled %>%
  filter(train == 1,
         validation == 0,
         stork_number == 1)

train_2_stork <-
  labeled %>%
  filter(train == 1,
         validation == 0,
         stork_number == 2)

train_3_stork <-
  labeled %>%
  filter(train == 1,
         validation == 0,
         stork_number == 3)


validation_0_stork <-
  labeled %>%
  filter(train == 1,
         validation == 1,
         stork_number == 0)

validation_1_stork <-
  labeled %>%
  filter(train == 1,
         validation == 1,
         stork_number == 1)

validation_2_stork <-
  labeled %>%
  filter(train == 1,
         validation == 1,
         stork_number == 2)

validation_3_stork <-
  labeled %>%
  filter(train == 1,
         validation == 1,
         stork_number == 3)

test <-
  labeled %>%
  filter(train == 0)


# copy the files into the respective folders (the original images were kept)
# train
file.copy(from = here("images", "2019_sampled", train_0_stork$filename),
          to = here("images", "2019_train", "train", "0_stork", train_0_stork$filename))

file.copy(from = here("images", "2019_sampled", train_1_stork$filename),
          to = here("images", "2019_train", "train", "1_stork", train_1_stork$filename))

file.copy(from = here("images", "2019_sampled", train_2_stork$filename),
          to = here("images", "2019_train", "train", "2_stork", train_2_stork$filename))

file.copy(from = here("images", "2019_sampled", train_3_stork$filename),
          to = here("images", "2019_train", "train", "3_stork", train_3_stork$filename))



# validation
file.copy(from = here("images", "2019_sampled", validation_0_stork$filename),
          to = here("images", "2019_train", "validation", "0_stork", validation_0_stork$filename))

file.copy(from = here("images", "2019_sampled", validation_1_stork$filename),
          to = here("images", "2019_train", "validation", "1_stork", validation_1_stork$filename))

file.copy(from = here("images", "2019_sampled", validation_2_stork$filename),
          to = here("images", "2019_train", "validation", "2_stork", validation_2_stork$filename))

file.copy(from = here("images", "2019_sampled", validation_3_stork$filename),
          to = here("images", "2019_train", "validation", "3_stork", validation_3_stork$filename))


# test
file.copy(from = here("images", "2019_sampled", test$filename),
          to = here("images", "2019_test", test$filename))


