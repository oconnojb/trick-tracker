require './config/environment'

use Rack::MethodOverride
use DogsController
use TricksController
run ApplicationController
