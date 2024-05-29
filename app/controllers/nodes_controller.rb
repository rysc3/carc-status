class NodesController < ApplicationController
  before_action :set_node, only: [:show, :edit, :update, :destroy]

  def index
    host = '129.24.245.8'
    username = 'ryan'
    private_key = 'app/assets/keys/server_key.pem'

    begin
      Net::SSH.start(host, username, keys: [private_key]) do |ssh|
        # Get hostname
        result_hostname = ssh.exec!("hostname")
        @hostname = result_hostname&.strip  # Use &. to safely call strip on result if it's not nil

        # Get system time
        result_time = ssh.exec!("date")
        @system_time = result_time&.strip
      end
    rescue Net::SSH::AuthenticationFailed
      flash[:error] = "Authentication failed. Please check your credentials."
      @hostname = nil
      @system_time = nil
    rescue StandardError => e
      flash[:error] = "Failed to fetch hostname or system time: #{e.message}"
      @hostname = nil
      @system_time = nil
    end
  end

  def show
  end

  def new
    @node = Node.new
  end

  def edit
  end

  def create
    @node = Node.new(node_params)

    if @node.save
      redirect_to @node, notice: 'Node was successfully created.'
    else
      render :new
    end
  end

  def update
    if @node.update(node_params)
      redirect_to @node, notice: 'Node was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @node.destroy
    redirect_to nodes_url, notice: 'Node was successfully destroyed.'
  end

  private
    def set_node
      @node = Node.find(params[:id])
    end

    def node_params
      params.require(:node).permit(:name, :id)
    end
end
