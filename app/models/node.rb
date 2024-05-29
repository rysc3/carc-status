class Node < ApplicationRecord
  validates :NodeName, presence: true, uniqueness: true

  def self.update_or_create_by_node_info(node_data)
    node = find_or_initialize_by(NodeName: node_data[:NodeName])
    node.update(node_data)
  end
end
