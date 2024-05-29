require 'net/ssh'

class NodesController < ApplicationController
  before_action :update_nodes, only: [:index, :show]

  def index
    @nodes = Node.all
  end

  def show
    @node = Node.find(params[:id])
  end

  def test_connection
    host = '129.24.245.8'
    username = 'ryan'
    private_key = 'app/assets/keys/server_key.pem'

    begin
      Net::SSH.start(host, username, keys: [private_key]) do |ssh|
        # Execute the hostname command
        result_hostname = ssh.exec!("hostname")
        @hostname = result_hostname&.strip
        result_date = ssh.exec!("date")
        @date = result_date&.strip
      end
    rescue Net::SSH::AuthenticationFailed
      flash[:error] = "Authentication failed. Please check your credentials."
      @hostname = nil
      @date = nil
    rescue StandardError => e
      flash[:error] = "Failed to fetch hostname: #{e.message}"
      @hostname = nil
      @date = nil
    end
  end

  def update_nodes
    host = '129.24.245.8'
    username = 'ryan'
    private_key = 'app/assets/keys/server_key.pem'

    begin
      Net::SSH.start(host, username, keys: [private_key]) do |ssh|
        # Get nodes info
        result_nodes = ssh.exec!("scontrol show node -a")
        nodes_info = result_nodes.split("\n\n")

        nodes_info.each do |node_info|
          node_name = get_node_name(node_info)
          update_node(node_name, node_info)
        end
      end
    rescue Net::SSH::AuthenticationFailed
      flash[:error] = "Authentication failed. Please check your credentials."
    rescue StandardError => e
      flash[:error] = "Failed to fetch data: #{e.message}"
    end
  end

  def get_node_name(node_info)
    first_line = node_info.lines.first
    node_name = first_line.match(/NodeName=([^\s]+)/)[1] if first_line.include?("NodeName=")
    node_name
  end

  def update_node(node_name, node_info)
    node = Node.find_or_initialize_by(NodeName: node_name)

    node_data = {}

    node_info.each_line do |line|
      line.chomp!

      if line.include?("CoresPerSocket=")
        node_data[:CoresPerSocket] = line.match(/CoresPerSocket=(\d+)/)[1].to_i
      elsif line.include?("CPUAlloc=")
        node_data[:CPUAlloc] = line.match(/CPUAlloc=(\d+)/)[1].to_i
      elsif line.include?("CPULoad=")
        node_data[:CPULoad] = line.match(/CPULoad=([\d.]+)/)[1].to_f
      elsif line.include?("RealMemory=")
        node_data[:RealMemory] = line.match(/RealMemory=(\d+)/)[1].to_i
      elsif line.include?("AllocMem=")
        node_data[:AllocMem] = line.match(/AllocMem=(\d+)/)[1].to_i
      elsif line.include?("FreeMem=")
        node_data[:FreeMem] = line.match(/FreeMem=(\d+)/)[1].to_i
      elsif line.include?("Sockets=")
        node_data[:Sockets] = line.match(/Sockets=(\d+)/)[1].to_i
      elsif line.include?("Boards=")
        node_data[:Boards] = line.match(/Boards=(\d+)/)[1].to_i
      elsif line.include?("State=")
        node_data[:State] = line.match(/State=([^\s]+)/)[1]
      elsif line.include?("ThreadsPerCore=")
        node_data[:ThreadsPerCore] = line.match(/ThreadsPerCore=(\d+)/)[1].to_i
      elsif line.include?("Partitions=")
        node_data[:Partitions] = line.match(/Partitions=([^\s]+)/)[1]
      elsif line.include?("CurrentWatts=")
        node_data[:CurrentWatts] = line.match(/CurrentWatts=(\d+)/)[1].to_i
      elsif line.include?("AveWatts=")
        node_data[:AveWatts] = line.match(/AveWatts=(\d+)/)[1].to_i
      end
    end

    node.update(node_data)
  end

  def set_node
    @node = Node.find(params[:id])
  end
end
