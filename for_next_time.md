## for next time:
[x] create migrations for :users :dogs :tricks :dog_tricks
[x] #place methods (1.place returns "first") for integer class?
[x]  Dog dob??? -- actually: Dog age
[] RESTful Routes
  - probably will look nicest to do different controllers

  [] user_controller
  x-home page (links to login or signup) -or- redirect '/dogs' if logged_in?
  x-sign up
  x-log in
  -edit my info
  -delete my account (and all assc data in database)

  [] dog_controller
  Cx- adopt a new dog
  Rx- show all of my dogs
  Rx- show one specific dog (-x-name slug?)
  U- edit an existing dog
  D- delete an existing dog

  [] trick_controller
  C- create a new trick
  R- show all of the tricks that i have taught at least one dog
  R- show the details of one specific trick (slug?)
  U- edit an existing trick's details
  D- delete an existing trick
