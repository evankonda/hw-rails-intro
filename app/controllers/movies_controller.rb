class MoviesController < ApplicationController

    def show
      id = params[:id] # retrieve movie ID from URI route
      @movie = Movie.find(id) # look up movie by unique ID
      # will render app/views/movies/show.<extension> by default
    end
  
    def index
      # general all ratings for index html
      @all_ratings = Movie.all_ratings
      
      # set movies to check boxed movies or session
      @checked = params[:ratings] || session[:ratings]
      # if checkboxes ar emtpy, set to all movies
      if @checked == nil
        @checked = Movie.all_ratings
        session[:ratings] = @checked
      # if the a session does not match the current parameters, reset session
      else
        # no match in sort method?
        if session[:sort_method] != params[:sort_method]
          session[:sort_method] = params[:sort_method] || session[:sort_method]
        # no match in ratings checkbox?
        elsif session[:ratings] != params[:ratings]
          session[:ratings] = @checked
        end
        # redirect to new URI containing updated parameters
        redirect_to :sort_method => session[:sort_method], :ratings => @checked
      end
        
      # get sorting method
      @sorter = params[:sort_method] || session[:sort_method]
      # sort by sorting method and do coloring
      if @sorter == 'title'
        @movies = @movies.order(@sorter)
        @sort_title = "hilite bg-warning"
      elsif @sorter == 'release_date'
        @movies = @movies.order(@sorter)
        @sort_rd = "hilight bg-warning"
      end
      
      # will keep same rating upon refresh
      @checked_ratings = @checked
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