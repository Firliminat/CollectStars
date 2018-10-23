# Classe des étoiles
class Star
  attr_reader :x, :y

  # Initialisation d'une étoiles
  # Set up l'image de l'animation, la couleur et la position.
  def initialize(animation)
    # cf. media/star.png
    @animation = animation
    @color = Gosu::Color::BLACK.dup
    @color.red = rand(256 - 40) + 40
    @color.green = rand(256 - 40) + 40
    @color.blue = rand(256 - 40) + 40
    @x = (rand * 640.0)
    @y = (rand * 480.0)
  end

  # Fonction d'affichage
  def draw
    # Charge une nouvelle étape d'animation toutes les 0.1s
    img = @animation[Gosu.milliseconds / 100 % @animation.size]
    # Affichage de l'étape d'animation.
    img.draw(@x - img.width / 2.0, @y - img.height / 2.0, ZOrder::STARS, 1, 1,\
      @color, :add)
  end

  # Calcul de la distance à une étoiles
  def distance(x, y)
    return Math::hypot(@x - x, @y - y)
  end
end
