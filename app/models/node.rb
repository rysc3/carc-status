class Node < ApplicationRecord
  validates :NodeName, presence: true, uniqueness: true
  # validates :id, presence: true, uniqueness: true

end
