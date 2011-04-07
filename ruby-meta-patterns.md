!SLIDE
# method missing pattern
## Marcos Vanetta (aka malev)
*http://blog.malev.com.ar*

**2011**

!SLIDE
# Method missing

Que pasa cuando llamamos a un metodo que no existe?

!SLIDE code
@@@ ruby
9.no_existe

> NoMethodError: undefined method `no_existe' for 9:Fixnum
	from (irb):1

!SLIDE
# method missing pattern

Consiste en crear un metodo generico que pueda recibir mensajes en ppio desconocidos.

*no es una definicion de manual*

!SLIDE
# Como busca los metodos ruby?

* busca en la clase
* busca en los modulos incluidos
* busca en la cadena de clases padres
* busca en object (de donde heredan todos los objetos)
* se fija si existe method_missing
* nos tira una *exception*

!SLIDE
# method_missing
*Entre la cadena de busqueda de metodos y la exception*

!SLIDE code
@@@ ruby

9.no_existe
NoMethodError: undefined method `no_existe' for 9:Fixnum

class Fixnum
  def method_missing(m, *args, &block)
        puts "There's no method called #{m}."
  end
end

9.noexiste
@@@

!SLIDE
# Un ejemplo?

!SLIDE
# Rails 2.3.5
## ActionMailer
* nosotros definimos un metodo
* y luego llamamos a un metodo parecido pero cuyo nombre empieza con deliver_XXX
* un metodo es de instancia y el otro de clase
* magia negra?


*la version 3 tambien tiene algo parecido pero no tan facil de ver*

!SLIDE code
@@@ ruby
    class UserMailer < ActionMailer::Base
        def welcome_email(user)
            recipients user.email
            ...
        end
    end
    ...
    UserMailer.deliver_welcome_email(user)
@@@

!SLIDE code
@@@ ruby
    class Base
      ...
      def method_missing(method_symbol, *parameters)
        if match = matches_dynamic_method?(method_symbol)
          case match[1]
            ...
            when 'deliver' then new(match[2], *parameters).deliver!
            ...
            else super
          end
        else
          super
        end
      end
    end
@@@

!SLIDE code
*y si queremos testear la existencia del metodo?*

!SLIDE
# Reescribimos respond_to? y listo!

!SLIDE code
@@@ ruby
  class Base
     ...
     def respond_to?(method_symbol, include_private = false)
           matches_dynamic_method?(method_symbol) || super
     end
     ...
  end
@@@

!SLIDE
## Muchas gracias
*http://blog.malev.com.ar*
