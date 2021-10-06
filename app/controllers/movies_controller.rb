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
      
      # Ratings
      # if either params or session has ratings
      if params.has_key?(:ratings) || session.has_key?(:ratings)
        # set checked to params. If no params, them to session
        @checked = params[:ratings] || session[:ratings]
        @movies = Movie.where(rating: @checked.keys)
        @checked_ratings = @checked
        if !params.has_key?(:ratings)
          params[:ratings] = @checked # no params, session is current values
        else
          session[:ratings] = params[:ratings] # params exist, session is params
        end
      else
        @checked_ratings = @all_ratings
        @movies = Movie.all
      end
      
      # Title Sorting
      # same methodology as above
      if params.has_key?(:sort_method) || session.has_key?(:sort_method)
        @sorter = params[:sort_method] || session[:sort_method]
        @movies = @movies.order(@sorter)
        # set sorting table header colors
        if @sorter == 'title'
          @coloring_title = true
        elsif @sorter == 'release_date'
          @coloring_rd = true
        end
        if !params.has_key?(:sort_method)
          params[:sort_method] = @sorter
        else
          session[:sort_method] = params[:sort_method]
        end
      else
        @movies = @movies
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