module Chambermaid
  GitDir = __FILE__[/(.+)\.rb$/, 1]
  def GitDir.create(destination)
    FileUtils.cp_r self, destination
  end
end
