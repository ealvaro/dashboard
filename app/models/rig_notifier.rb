class RigNotifier < UpdateNotifier
  alias_attribute :rig, :notifierable

  def self.find_by_rig rig
    return [] unless rig
    RigNotifier.where(notifierable: rig)
  end
end