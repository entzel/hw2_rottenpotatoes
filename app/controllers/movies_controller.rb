class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    #debugger
    #Ratings from the model
    @all_ratings = Movie.all_ratings

    #Find the parameters from the params hash, 
    @order_by= params[:order_by]
    @ratings = params[:ratings]

    #No sort selected, don't redirect yet
    @redirect = false

    #Check if there is session data, if there is set it
    if (@order_by.nil? and not session[:order_by].nil?)
      @order_by = session[:order_by]
      @redirect = true
    end
    if (@ratings.nil? and not session[:ratings].nil?)
      @ratings = session[:ratings]
      @redirect = true
    end
    #redirect to the new index page based off session data that alerts to order change
    if (@redirect  == true)
      flash.keep
      #can't use movies_path from movies_path
      redirect_to :action => 'index', :ratings => @ratings, :order_by => @order_by
    end

    #store user made changes in session data
    if not @ratings.nil? 
      session[:ratings] = @ratings
    else
      #If ratings are empty make an empty hash
      @ratings = Hash[Movie.all_ratings.collect {|r| [r, r] }]
    end

    #if the title exists, store it to sort 
    if not @header.nil?  then session[:header] = @header; end
  

    #sort by ratings and order by header
    @movies = Movie.where(rating: @ratings.keys).order(@header)
    
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
