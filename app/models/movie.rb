class Movie < ActiveRecord::Base
	def Movie.all_ratings
		['R', 'PG-13', 'PG', 'G']
	end
end
