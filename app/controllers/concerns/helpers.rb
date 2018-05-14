module ApplicationHelper

  def logged_in?
    !!session[:user_id]
  end

  def current_user
    User.find(session[:user_id])
  end

  def place(integer)
    placement_array = [
      'zeroth', 'first', 'second', 'third',
      'fourth', 'fifth', 'sixth', 'seventh',
      'eighth', 'ninth', 'tenth', 'eleventh',
      'twelfth', 'thirteenth', 'fourteenth',
      'fifteenth', 'sixteenth', 'seventeenth',
      'eighteenth', 'nineteenth', 'twentieth']
    if integer.between?(1, 20)
      return placement_array[integer]
    else
      return integer.to_s
    end
  end

end
