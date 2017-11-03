class SmartTool < Tool
  has_many :dumb_tools
  validates :uid, uniqueness: true, presence: true, allow_nil: false, length: {minimum: 8}
end