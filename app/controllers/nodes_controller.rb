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
        hostname = result_hostname&.strip  # Use &. to safely call strip on result if it's not nil

        # Get system time
        result_time = ssh.exec!("date")
        system_time = result_time&.strip

        # Get nodes info
        result_nodes = ssh.exec!("scontrol show node -a")
        nodes_info = result_nodes.split("\n\n")

        nodes_info.each do |node_info|
          node_data = parse_node_info(node_info)
          node = Node.find_or_initialize_by(name: node_data[:nodename])
          node.update(node_data)
          node.last_updated = Time.now
          node.save
        end

        @hostname = hostname
        @system_time = system_time
        @nodes = Node.all
      end
    rescue Net::SSH::AuthenticationFailed
      flash[:error] = "Authentication failed. Please check your credentials."
      @hostname = nil
      @system_time = nil
      @nodes = []
    rescue StandardError => e
      flash[:error] = "Failed to fetch data: #{e.message}"
      @hostname = nil
      @system_time = nil
      @nodes = []
    end
  end

  def show
  end

  def test_connection
    host = '129.24.245.8'
    username = 'ryan'
    private_key = 'app/assets/keys/server_key.pem'

    begin
      Net::SSH.start(host, username, keys: [private_key]) do |ssh|
        # Execute the hostname command
        result_hostname = ssh.exec!("hostname")
        @hostname = result_hostname&.strip  # Use &. to safely call strip on result if it's not nil
        result_date = ssh.exec!("date")
        @date = result_date&.strip
      end
    rescue Net::SSH::AuthenticationFailed
      flash[:error] = "Authentication failed. Please check your credentials."
      @hostname = nil
    rescue StandardError => e
      flash[:error] = "Failed to fetch hostname: #{e.message}"
      @hostname = nil
    end
  end

  private

  def parse_node_info(node_info)
    node_data = {}
    node_info.each_line do |line|
      key, value = line.strip.split('=', 2)
      node_data[key.downcase.to_sym] = value
    end
    node_data[:last_updated] = Time.now
    node_data
  end

  def set_node
    @node = Node.find(params[:id])
  end
end
