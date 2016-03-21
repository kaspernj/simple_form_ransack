require "ransack"

# This saves the params given to Ransack, so they can be recalled later
class Ransack::Search
  alias old_build build

  def build(params = {})
    @_registered_params = params
    old_build(params)
  end
end
