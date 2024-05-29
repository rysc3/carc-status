class NodesController < ApplicationController
  before_action :load_nodes, only: [:index, :show]

  def index
    @nodes = Node.all
  end

  def show
    @node = Node.find(params[:id])
  end

  private

  def load_nodes
    @nodes = Node.all
  end
end
