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

        result_hostname = ssh.exec!("hostname")
        hostname = result_hostname&.strip

        nodes_info.each do |node_info|
          node_data = parse_node_info(node_info, hostname)
          node = Node.find_by(NodeName: node_data[:NodeName])

          if node
            # Update existing node
            node.update(node_data)
          else
            # Create new node
            Node.create(node_data)
          end
        end
      end
    rescue Net::SSH::AuthenticationFailed
      flash[:error] = "Authentication failed. Please check your credentials."
    rescue StandardError => e
      flash[:error] = "Failed to fetch data: #{e.message}"
    end
  end


  def parse_node_info(node_info, hostname)
    node_data = {}
    node_name = ""

    node_info.each_line do |line|
      line.chomp!  # Remove newline character
      key, value = line.split('=', 2)

      if key == "NodeName"
        node_name = value.split.first  # Extract NodeName up to the first space
      end
    end

    # Check if NodeName is present
    if node_name.present?
      node = Node.find_by(NodeName: node_name)

      # If node exists, update its attributes
      if node
        node.update(NodeName: node_name)
      else
        # Otherwise, create a new node
        Node.create(NodeName: node_name)
      end
    end

    # Print out the parsed node data
    puts "-------------------"
    puts "Parsed Node Data: #{node_data.inspect}"
    puts "-------------------"

    node_data
  end

  def set_node
    @node = Node.find(params[:id])
  end
end
