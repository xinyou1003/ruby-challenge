require 'rest_client'
require 'json'
require 'htmlentities'

class IssuesController < ApplicationController
  before_action :set_issue, only: [:show, :edit, :update, :destroy]
  def get_issues_rest
    # Fetch 100 repositories sorted by starrs
    endpoint = 'https://api.github.com/repos/sinatra/sinatra/issues'
    url = "#{endpoint}"
    
    
    repos = []
    # Fetch the top 1000 repositories (10 pages)
    (1..1).each do |page|
      # Fetch the data and parse the JSON response
      puts "Fetching repos from page #{page}"; STDOUT.flush;
      repos_raw = RestClient.get url, :accept => "application/vnd.github.preview"
      # puts repos_raw
      @issues = JSON(repos_raw)
      
      # issues.each do |i|
      #  puts i['title']
      #  puts i['body']
      #  puts i['url']
      #  puts i['state']
      # end
      # repos.concat(JSON(repos_raw)["items"])
      # Sleep 15 seconds to avoid hitting the API limits for unauthenticated calls
      # sleep(15)
    end
  end


  # GET /issues
  # GET /issues.json
  def index
    # @issues = Issue.all
    get_issues_rest
    @coder = HTMLEntities.new
    # render :nothing => true
  end

  # GET /issues/1
  # GET /issues/1.json
  def show
  end

  # GET /issues/new
  def new
    @issue = Issue.new
  end

  # GET /issues/1/edit
  def edit
  end

  # POST /issues
  # POST /issues.json
  def create
    @issue = Issue.new(issue_params)

    respond_to do |format|
      if @issue.save
        format.html { redirect_to @issue, notice: 'Issue was successfully created.' }
        format.json { render action: 'show', status: :created, location: @issue }
      else
        format.html { render action: 'new' }
        format.json { render json: @issue.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /issues/1
  # PATCH/PUT /issues/1.json
  def update
    respond_to do |format|
      if @issue.update(issue_params)
        format.html { redirect_to @issue, notice: 'Issue was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @issue.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /issues/1
  # DELETE /issues/1.json
  def destroy
    @issue.destroy
    respond_to do |format|
      format.html { redirect_to issues_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_issue
      @issue = Issue.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def issue_params
      params[:issue]
    end
end
