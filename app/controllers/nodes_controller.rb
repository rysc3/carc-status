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
    # host = 'hopper.alliance.unm.edu'
    # username = 'rdscher'

    host = '129.24.245.8'
    username = 'ryan'

    private_key = 'app/assets/keys/server_key.pem'

    begin
      Net::SSH.start(host, username, keys: [private_key]) do |ssh|
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

  private

  def update_nodes
    host = '129.24.245.8'
    username = 'ryan'

    private_key = 'app/assets/keys/server_key.pem'

    begin
      Net::SSH.start(host, username, keys: [private_key]) do |ssh|
        result_nodes = ssh.exec!("scontrol show node -a")
        nodes_info = result_nodes.split("\n\n") # Split by double newline to separate nodes

        nodes_info.each do |node_info|
          update_or_create_node(node_info)
        end
      end
    rescue Net::SSH::AuthenticationFailed
      flash[:error] = "Authentication failed. Please check your credentials."
    rescue StandardError => e
      flash[:error] = "Failed to fetch data: #{e.message}"
    end
  end

  def update_or_create_node(node_info)
    node_data = parse_node_data(node_info)
    node = Node.find_by(NodeName: node_data[:NodeName])

    if node
      node.update(node_data)
    else
      Node.create(node_data)
    end
  end

  def parse_node_data(node_info)
    node_data = {}

    node_info.each_line do |line|
      line.chomp!

      if line.include?("NodeName=")
        node_data[:NodeName] = line.match(/NodeName=([^\s]+)/)[1]
      else
        node_data.merge!(parse_line(line))
      end
    end

    node_data
  end

  def parse_line(line)
    data = {}

    if line.include?("CoresPerSocket=")
      data[:CoresPerSocket] = line.match(/CoresPerSocket=(\d+)/)[1].to_i
    end
    if line.include?("CPUAlloc=")
      data[:CPUAlloc] = line.match(/CPUAlloc=(\d+)/)[1].to_i
    end
    if line.include?("CPULoad=")
      data[:CPULoad] = line.match(/CPULoad=([\d.]+)/)[1].to_f
    end
    if line.include?("RealMemory=")
      data[:RealMemory] = line.match(/RealMemory=(\d+)/)[1].to_i
    end
    if line.include?("AllocMem=")
      data[:AllocMem] = line.match(/AllocMem=(\d+)/)[1].to_i
    end
    if line.include?("FreeMem=")
      data[:FreeMem] = line.match(/FreeMem=(\d+)/)[1].to_i
    end
    if line.include?("Sockets=")
      data[:Sockets] = line.match(/Sockets=(\d+)/)[1].to_i
    end
    if line.include?("Boards=")
      data[:Boards] = line.match(/Boards=(\d+)/)[1].to_i
    end
    if line.include?("State=")
      data[:State] = line.match(/State=([^\s]+)/)[1]
    end
    if line.include?("ThreadsPerCore=")
      data[:ThreadsPerCore] = line.match(/ThreadsPerCore=(\d+)/)[1].to_i
    end
    if line.include?("Partitions=")
      data[:Partitions] = line.match(/Partitions=([^\s]+)/)[1]
    end
    if line.include?("CurrentWatts=")
      data[:CurrentWatts] = line.match(/CurrentWatts=(\d+)/)[1].to_i
    end
    if line.include?("AveWatts=")
      data[:AveWatts] = line.match(/AveWatts=(\d+)/)[1].to_i
    end

    data
  end

end
