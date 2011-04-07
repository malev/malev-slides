class Saludo
  def initialize(sal="hola")
    @saludo = sal
  end

  def method_missing(m, *args, &block)
    puts "hola que tal"
  end
end
