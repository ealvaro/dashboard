class JobSerializer < JobShallowSerializer
  has_many :runs
  has_one :client, serializer: ClientShallowSerializer
end
