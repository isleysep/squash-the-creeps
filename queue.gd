extends Node3D

# On phase 2, create a face with random assigned button, add to list
# Each face has a script that takes in the random button as an initialization parameter and sets that button's image to the filled in circle.
# On each successful input, destroy face and slide others into place to fill, play twirl animation
# Other faces have lower opacity to draw attention to main, but still visible enough to look ahead
# On unsuccessful input, ? probably restart that specific line from beginning rather than reset the whole combo but see what feels right
# Timing element?
# On successful last input, create new line using list of inputs so far, update score tracking
