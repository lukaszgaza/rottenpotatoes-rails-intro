class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index

    @all_ratings = Movie.ratings

    session[:ratings] ||= @all_ratings

    @sort_by = params[:sort_by].to_sym if params[:sort_by] == 'title' or params[:sort_by] == 'release_date'

    # storing passed values of :ratings and :sort_by
    session[:ratings] = params[:ratings].keys if params[:ratings]
    session[:sort_by] = @sort_by if @sort_by

    @ratings = session[:ratings]
    @sort_by = session[:sort_by].to_sym if session[:sort_by]

    redirect_to movies_path sort_by: @sort_by, ratings: Hash[@ratings.map {|k| [k,1]}] unless params[:ratings]

    if @sort_by
      @movies = Movie.order(@sort_by)
    else
      @movies = Movie.all
    end

    @movies = @movies.where(rating: @ratings)
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
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
