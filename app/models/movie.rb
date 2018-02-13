class Movie < ActiveRecord::Base
  def Movie.ratings
    Movie.pluck(:rating).uniq
  end
end
