## for next time:
[x]Delete one dog

## overall goals:
[x] create migrations for :users :dogs :tricks :dog_tricks
[x] #place methods (1.place returns "first") for integer class?
[x]  Dog dob??? -- actually: Dog age
[x] RESTful Routes
  - probably will look nicest to do different controllers

  [x] user_controller
  x-home page (links to login or signup) -or- redirect '/dogs' if logged_in?
  x-sign up
  x-log in
  x-edit my info
  x-delete my account (and all assc data in database)

  [x] dog_controller
  Cx- adopt a new dog
  Rx- show all of my dogs
  Rx- show one specific dog (-x-name slug?)
  Ux- edit an existing dog
  Dx- delete an existing dog

  [x] trick_controller
  Cx- create a new trick
  Rx- show all of the tricks that i have taught at least one dog
  Rx- show the details of one specific trick
  (U- edit an existing trick's details) - not going to do
  Ux- add a trick to a dogs rep
  Dx- delete an existing trick from a dogs rep
  x- cannot edit or delete tricks, all users pull from the same database
