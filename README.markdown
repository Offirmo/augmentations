# Augmentations

Too "fat" Rails models can be unmanageable. Also, sometimes you want to define or run the same methods in several different models.

*Augmentations* is a Rails plugin that provides a simple API for extending a model (or other class) with instance methods and class methods, as well as running class methods like `belongs_to` at extend time.

## Rails model extensions

This plugin uses regular Ruby modules, but with some additions.

My [Rails model extensions](http://henrik.nyh.se/2008/02/rails-model-extensions) article gives details on how you can use modules to extend Rails models. In brief:

You define a module like

    module Shared
      module Pingable
         # …
      end
    end
    
in `app/models/shared/pingable.rb`, or

    module User
      module PasswordResetExtension
         # …
      end
    end

in `app/models/user/password_reset_extension.rb`.


## Old style

Without this plugin, you would then include them in models like

    class User < ActiveRecord::Base
      include PasswordResetExtension,
              Shared::Pingable
    end
    
The `app/models/shared/pingable.rb` file could look something like

    module Shared
      module Pingable
    
        def an_instance_method
          # …
        end
    
        def self.included(klass)
          klass.class_eval do
            belongs_to :ping

            def self.a_class_method
              # …
            end
          end
        end
    
      end
    end
    
I have some issues with this:

 * There is too much boilerplate in the module, obscuring what you're actually adding.

 * Abusing the standard method `include` to not only add instance methods but also do stuff on the class level can be confusing. You could use `extend` as well, though this is more verbose. To get the `belongs_to`, you'd still need to use module hooks, or put another line of code in the model.

 * It looks different from how the code would look if defined in the model: the instance methods are in a different block of code than the class-level stuff – though you could get around this by putting everything in the `class_eval`.


## New style

Modules are still used, as described above, but the API is improved.

Use *Augmentations* like:

    class User < ActiveRecord::Base
      incorporate Shared::Pingable, PasswordResetExtension
    end
  
With modules like

    module Shared
      module Pingable
        augmentation do
        
          belongs_to :ping
          
          def self.a_class_method
            # …
          end

          def an_instance_method
            # …
          end

        end
      end
    end
  
What I like about this:

 * A new method, `incorporate`, is used, rather than abusing `include`.

 * Less boilerplate.
 
 * Keeps the code for class and instances together, looking just like it would do in the model. You could achieve this with `included` and `class_eval` as mentioned above, but it would not have the other benefits.
 
 * The plugin amounts to very little code and a straightforward implementation. It's basically lipstick on `included` and `class_eval`.
 
 * Compatible with rspec (some alternate methods are not, which is bad)
 
(If you want to weird things up in the name of fewer lines of code, the Ruby parser will accept

    module Shared
      module Pingable augmentation do
      
        …

      end end
    end
    
too.)


## To-do

Add support for module arguments; something like

    incorporate Shared::Pingable, :pong => false


## Credits and license

By [Henrik Nyh](http://henrik.nyh.se/) for [DanceJam](http://dancejam.com) under the MIT license:

>  Copyright (c) 2008 Henrik Nyh
>
>  Permission is hereby granted, free of charge, to any person obtaining a copy
>  of this software and associated documentation files (the "Software"), to deal
>  in the Software without restriction, including without limitation the rights
>  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
>  copies of the Software, and to permit persons to whom the Software is
>  furnished to do so, subject to the following conditions:
>
>  The above copyright notice and this permission notice shall be included in
>  all copies or substantial portions of the Software.
>
>  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
>  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
>  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
>  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
>  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
>  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
>  THE SOFTWARE.