## for next time:
[] create migrations for :users :dogs :tricks :dog_tricks
[] #place methods (1.place returns "first") for integer class?
[] RESTful Routes
  - probably will look nicest to do different controllers

  [] user_controller
  -home page (links to login or signup) -or- redirect '/dogs' if logged_in?
  -sign up
  -log in
  -edit my info
  -delete my account (and all assc data in database)

  [] dog_controller
  C- adopt a new dog
  R- show all of my dogs
  R- show one specific dog (name slug?)
  U- edit an existing dog
  D- delete an existing dog

  [] trick_controller
  C- create a new trick
  R- show all of the tricks that i have taught at least one dog
  R- show the details of one specific trick (slug?)
  U- edit an existing trick's details
  D- delete an existing trick
