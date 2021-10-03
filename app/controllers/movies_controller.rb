class MoviesController < ApplicationController

    def show
      id = params[:id] # retrieve movie ID from URI route
      @movie = Movie.find(id) # look up movie by unique ID
      # will render app/views/movies/show.<extension> by default
    end
  
    def index
      # general all ratings for index html
      @all_ratings = Movie.all_ratings
      # set heading coloring options to false 
      @coloring_title, @coloring_rd = false, false
      
      # set movies to check boxed movies
      if params.has_key?(:ratings)
        @checked = params[:ratings]
        @movies = Movie.where(rating: @checked.keys)
        @checked_ratings = @checked
      else
        @checked_ratings = @all_ratings
        @movies = Movie.all
      end
      
      # get sorting method
      @sorter = params[:sort_method]
      # sort by sorting method and do coloring
      if @sorter == 'title'
        @movies = @movies.order(@sorter)
        @coloring_title = true
      elsif @sorter == 'release_date'
        @movies = @movies.order(@sorter)
        @coloring_rd = true
      end
  

      
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
  
    private
    # Making "internal" methods private is not required, but is a common practice.
    # This helps make clear which methods respond to requests, and which ones do not.
    def movie_params
      params.require(:movie).permit(:title, :rating, :description, :release_date)
    end
  end