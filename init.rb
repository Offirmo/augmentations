# "Augmentations" plugin for Rails.
# By Henrik Nyh <http://henrik.nyh.se> under the MIT license for DanceJam <http://dancejam.com> 2008-09-10.
# See README for usage.

# Forked by Offirmo <https://github.com/Offirmo> because of a disagreement about the name of the function ;-)
# cf. http://henrik.nyh.se/2008/09/augmentations

class ::Object

  # the new "incorporate" word instead of "augment"
  def self.incorporate(*mods)
    include *mods
    mods.each {|mod| class_eval &mod.augmentation }
  end
  
  # The original "augment" word, semantically incorrect in my opinion.
  # Kept for compatibility.
	class << self
		alias augment incorporate
	end
	
end

class ::Module
  def augmentation(&block)
    @augmentation ||= block
  end
end
